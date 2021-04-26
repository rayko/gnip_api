module Gnip
  class Url < Gnip::Message
    extend Gnip::Parser

    attr_reader :url, :expanded_url, :expanded_status, :display_url, :indices, :expanded_url_title, :expanded_url_description, :raw

    def initialize params={}
      @raw = params
      @url = params['url']
      @display_url = params['display_url']
      @expanded_url = params['expanded_url']
      @expanded_status = params['expanded_status']
      @expanded_url_title = params['expanded_url_title']
      @expanded_url_description = params['expanded_url_description']
      @indices = params['indices']
    end

    def to_h
      {
        :url => @url,
        :display_url => @display_url,
        :expanded_url => @expanded_url,
        :expanded_status => @expanded_status,
        :expanded_url_title => @expanded_url_title,
        :expanded_url_description => @expanded_url_description,
        :indices => @indices
      }.delete_if{|k,v| v.nil?}
    end

    def to_json
      @raw.to_json
    end
  end
end
