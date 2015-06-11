module Gnip
  class Message
    def self.build params
      if params['error'] || params['warn'] || params['info']
        SystemMessage.new params
      elsif params['id']
        Activity.new params
      end
    end

    def system_message?
      false
    end

    def activity?
      false
    end
  end

  class SystemMessage < Message
    attr_accessor :message, :sent

    def initialize params
      @message = params['message']
      @sent = params['sent']
    end

    def system_message?
      true
    end
  end

  class Activity < Message
    attr_accessor :id, :actor, :object_type, :verb, :posted_time, :provider, :link, :body
    def initialize params = {}
      @id = params['id']
      @object_type = params['objectType']
      @verb = params['verb']
      @posted_time = params['postedTime']
      @provider = params['provider']
      @link = params['link']
      @body = retweet? ? params['object']['body'] : params['body']
      @actor = Actor.new params['actor']
    end

    def to_json
      {
        :id => @id,
        :actor => @actor.to_json,
        :object_type => @object_type,
        :verb => @verb,
        :posted_time => @posted_time,
        :provider => @provider,
        :link => @link,
        :body => @body
      }.to_json
    end

    def author
      actor.display_name
    end

    def activity?
      true
    end

    def retweet? 
      verb == 'share'
    end
  end
end
