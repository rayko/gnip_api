module Gnip
  class GnipData < Gnip::Message
    attr_reader :matching_rules, :urls, :language

    def initialize params={}
      @matching_rules = params['matching_rules'].map{|r| GnipApi::Apis::PowerTrack::Rule.new(r)} if params['matching_rules']
      @urls = (params['urls'] ? params['urls'].map{|u| Gnip::Url.new(u)} : [])
      @language = params['language']
    end

    def original_attributes
      {
        :matching_rules => @matching_rules.map(&:attributes),
        :urls => @urls.map(&:original_attributes),
        :language => @language
      }.delete_if{|k,v| v.nil?}
    end

    def to_json
      generate_json(original_attributes)
    end
  end
end
