module Gnip
  class Actor < Gnip::Message
    attr_reader :object_type, :id, :link, :display_name, :posted_time, :image, :summary,
    :links, :friends_count, :followers_count, :statuses_count, :twitter_time_zone, :verified,
    :utc_offset, :preferred_username, :languages, :location, :favorites_count
    
    def initialize params = {}
      @object_type = params['objectType']
      @id = params['id']
      @link = params['link']
      @display_name = params['displayName']
      @posted_time = params['postedTime']
      @image = params['image']
      @summary = params['summary']
      @links = params['links']
      @friends_count = params['friendsCount']
      @followers_count = params['followersCount']
      @listed_count = params['listedCount']
      @statuses_count = params['statusesCount']
      @twitter_time_zone = params['twitterTimeZone']
      @verified = params['verified']
      @utc_offset = params['utcOffset']
      @preferred_username = params['preferredUsername']
      @languages = params['languages'].join(',')
      @location = params['location']
      @favorites_count = params['favoritesCount']
    end

    def original_attributes
      {
        :objectType => @object_type,
        :id => @id,
        :link => @link,
        :displayName => @display_name,
        :postedTime => @posted_time,
        :image => @image,
        :summary => @summary,
        :links => @links,
        :friendsCount => @friends_count,
        :followersCount => @followers_count,
        :listedCount => @listed_count,
        :statusesCount => @statuses_count,
        :twitterTimeZone => @twitter_time_zone,
        :verified => @verified,
        :utcOffset => @utc_offset,
        :preferredUsername => @preferred_username,
        :languages => @languages.split(','),
        :location => @location,
        :favoritesCount => @favorites_count
      }
    end

    def user_id
      @id.split(':').last
    end

    def image
      Addressable::URI.parse(@image) unless @image.nil?
    end

    def to_json
      generate_json(original_attributes)
    end
  end
end
