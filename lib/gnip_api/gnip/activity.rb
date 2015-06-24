module Gnip
  class Activity
    attr_reader :id, :object_type, :actor, :verb, :posted_time, :generator, :provider, :link,
    :body, :object, :favorites_count, :twitter_entities, :twitter_filter_level, :twitter_lang,
    :retweet_count, :gnip

    def initialize params = {}
      @id = params['id']
      @object_type = params['objectType']
      @actor = Gnip::Actor.new params['actor']
      @verb = params['verb']
      @posted_time = params['postedTime']
      @generator = params['generator']
      @provider = params['provider']
      @link = params['link']
      @body = retweet? ? params['object']['body'] : params['body']
      @object = params['object']
      @favorites_count = params['favoritesCount']
      @twitter_entities = params['twitter_entities']
      @twitter_filter_level = params['twitter_filter_level']
      @twitter_lang = params['twitter_lang']
      @retweet_count = params['retweetCount']
      @gnip = params['gnip']
    end

    def original_attributes
      {
        :id => @id,
        :objectType => @object_type,
        :actor => @actor.original_attributes,
        :verb => @verb,
        :postedTime => @posted_time,
        :generator => @generator,
        :provider => @provider,
        :link => @link,
        :body => @body,
        :object => @object,
        :favoritesCount => @favorites_count,
        :twitter_entities => @twitter_entities,
        :twitter_filter_level => @twitter_filter_level,
        :twitter_lang => @twitter_lang,
        :retweetCount => @retweet_count,
        :gnip => @gnip
      }
    end

    def to_json
      original_attributes.to_json
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

