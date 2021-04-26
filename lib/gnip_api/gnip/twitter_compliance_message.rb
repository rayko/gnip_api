module Gnip
  class TwitterComplianceMessage < Gnip::Message
    extend Gnip::Parser

    attr_reader :raw, :object_type, :verb, :object, :actor, :timestamp_ms, :target, :withheld_in_countries

    def initialize params = {}
      @raw = params
      @object_type = params['objectType']
      @actor = params['actor']
      @verb = params['verb']
      @timestamp_ms = params['timestampMs']
      @object = params['object']
    end

    def to_h
      @raw
    end

    def timestamp_ms
      DateTime.parse(@timestamp_ms)
    end

    def to_json
      @raw.to_json
    end
  end
end

