# Gnip PowerTrack Rules API
#
# Create, delete and list rules of a powetrack stream.

module GnipApi
  module Apis
    module PowerTrack
      class Rules
        attr_reader :adapter

        # In order to do any operation, you need to specify:
        # - label: the label of your stream
        # - source: which data source to use (I think only twitter is available)
        def initialize params={}
          @adapter = GnipApi::Adapter.new
          @label = params[:label]
          @source = params[:source]
        end

        # Returns an array of defined rules
        def list
          request_allowed?
          request = create_request
          rules = adapter.get(request)
          parse_rules(rules)
        end

        # Creates the specified rule. Parameters:
        # - rules: GnipApi::Apis::PowerTrack::Rule object
        def create rules
          raise GnipApi::Errors::PowerTrack::MissingRules.new if rules.nil? || rules.empty?
          request_allowed?
          request = create_request(construct_rules(rules))
          adapter.post(request)
        end

        # Deletes the specified rule. Parameters:
        # - rules: GnipApi::Apis::PowerTrack::Rule object
        def delete rules
          raise GnipApi::Errors::PowerTrack::MissingRules.new if rules.nil? || rules.empty?
          request_allowed?
          request = create_request(construct_rules(rules))
          adapter.delete(request)
        end

        # Parses an array of GnipApi::Apis::PowerTrack::Rule objects
        # to the necesary JSON format for the endpoint
        def construct_rules rules
          parsed_rules = {:rules => []}
          rules.each do |rule|
            parsed_rules[:rules] << rule.attributes
          end
          parsed_rules.to_json
        end

        def parse_rules data
          parsed_data = JSON.parse(data)
          parsed_data['rules'].map{|rule| GnipApi::Apis::PowerTrack::Rule.new(:value => rule['value'], :tag => rule['tag'])}
        end

        private
        def endpoint
          GnipApi::Endpoints.powertrack_rules(@source, @label)
        end

        def create_request payload=nil
          GnipApi::Request.new(endpoint, payload)
        end

        def request_allowed?
          raise 'RateLimited' unless GnipApi.config.rate_limiter.rules_request_allowed?
        end
      end
    end
  end
end
