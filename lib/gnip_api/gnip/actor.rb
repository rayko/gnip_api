module Gnip
  class Actor
    attr_accessor :id, :object_type, :link, :display_name, :image, :summary,
    :location, :friends_count, :followers_count, :statuses_count
    
    def initialize params = {}
      @id = params['id']
      @object_type = params['objectType']
      @link = params['link']
      @display_name = params['displayName']
      @image = params['image']
      @summary = params['summary']
      @location = params['location']
      @friends_count = params['friendsCount']
      @followers_count = params['followersCount']
      @statuses_count = params['statusesCount']
    end

    def to_json
      {
        :id => @id,
        :object_type => @object_type,
        :link => @link,
        :display_name => @display_name,
        :image => @image,
        :summary => @summary,
        :location => @location,
        :friends_count => @friends_count,
        :followers_count =>  @followers_count,
        :statuses_count => @statuses_count
      }
    end
  end
end
