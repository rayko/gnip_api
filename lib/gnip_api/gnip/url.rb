module Gnip
  class Url < Gnip::Message
    attr_reader :url, :expanded_url, :expanded_status, :display_url, :indices, :expanded_url_title, :expanded_url_description

    def initialize params={}
      @url = params['url']
      @expanded_url = params['expanded_url']
      @display_url = params['display_url']
      @expanded_status = params['expanded_status']
      @indices = params['indices']
      @expanded_url_title = params['expanded_url_title']
      @expanded_url_description = params['expanded_url_description']
    end

    def url
      Addressable::URI.parse(@url) unless @url.nil?
    end
    
    def expanded_url
      Addressable::URI.parse(@expanded_url) unless @expanded_url.nil?
    end

    def original_attributes
      {
        :url => @url,
        :title => @title,
        :display_url => @display_url,
        :expanded_url => @expanded_url,
        :expanded_status => @expanded_status,
        :indices => @indices
      }.delete_if{|k,v| v.nil?}
    end

    def to_json
      generate_json(original_attributes)
    end
  end
end
