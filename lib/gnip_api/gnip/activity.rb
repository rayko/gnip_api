module Gnip
  class Activity < Gnip::Message
    extend Gnip::Parser

    attr_reader :id, :object_type, :actor, :verb, :posted_time, :generator, :provider, :link,
    :body, :object, :favorites_count, :twitter_entities, :twitter_filter_level, :twitter_lang,
    :retweet_count, :gnip, :raw, :long_object, :display_text_range

    def initialize params = {}
      @raw = params
      @id = params['id']
      @object_type = params['objectType']
      @actor = Gnip::Actor.new params['actor']
      @verb = params['verb']
      @posted_time = params['postedTime']
      @generator = params['generator']
      @provider = params['provider']
      @link = params['link']
      @body = params['body']
      @object = retweet? ? Gnip::Activity.new(params['object']) : params['object']
      @favorites_count = params['favoritesCount']
      @twitter_entities = params['twitter_entities']
      @twitter_filter_level = params['twitter_filter_level']
      @twitter_lang = params['twitter_lang']
      @retweet_count = params['retweetCount']
      @long_object = params['long_object']
      @display_text_range = params['display_text_range']
      @gnip = Gnip::GnipData.new(params['gnip']) if params['gnip']
    end

    def to_h
      {
        :id => @id,
        :objectType => @object_type,
        :actor => @actor.to_h,
        :verb => @verb,
        :postedTime => @posted_time,
        :generator => @generator,
        :provider => @provider,
        :link => @link,
        :body => @body,
        :object => @object.kind_of?(Gnip::Activity) ? @object.to_h : @object,
        :favoritesCount => @favorites_count,
        :twitter_entities => @twitter_entities,
        :twitter_filter_level => @twitter_filter_level,
        :twitter_lang => @twitter_lang,
        :retweetCount => @retweet_count,
        :longObject => @long_object,
        :display_text_range => @display_text_range,
        :gnip => @gnip ? @gnip.to_h : nil
      }
    end

    def posted_time
      DateTime.parse(@posted_time)
    end

    def link
      Addressable::URI.parse(@link) unless @link.nil?
    end

    def tweet_id
      @id.split(':').last
    end

    def to_json
      @raw.to_json
    end

    def author
      actor.display_name
    end

    def retweet? 
      verb == 'share'
    end

    def hidden_data?
      !@display_text_range.nil? && !@long_object.nil?
    end
  end
end

