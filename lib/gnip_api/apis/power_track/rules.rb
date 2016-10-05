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
          @label = params[:label] || GnipApi.config.label
        end

        # Returns an array of defined rules
        def list
          request = create_get_request
          rules = adapter.get(request)
          parse_rules(rules)
        end

        # Creates the specified rule. Parameters:
        # - rules: GnipApi::Apis::PowerTrack::Rule object
        def create rules
          raise GnipApi::Errors::PowerTrack::MissingRules.new if rules.nil? || rules.empty?
          request = create_post_request(construct_rules(rules))
          response = adapter.post(request)
          return true if response.nil?
          return GnipApi::JsonParser.new.parse(response)
        end

        # Deletes the specified rule. Parameters:
        # - rules: GnipApi::Apis::PowerTrack::Rule object
        def delete rules
          raise GnipApi::Errors::PowerTrack::MissingRules.new if rules.nil? || rules.empty?
          request = create_delete_request(construct_rules(rules))
          response = adapter.delete(request)
          return true if response.nil?
          return GnipApi::JsonParser.new.parse(response)
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
          parsed_data = GnipApi::JsonParser.new.parse(data)
          parsed_data['rules'].map{|rule| GnipApi::Apis::PowerTrack::Rule.new(:value => rule['value'], :tag => rule['tag'], :id => rule['id'])}
        end

        private
        def endpoint
          GnipApi::Endpoints.powertrack_rules(@label)
        end

        def create_get_request
          GnipApi::Request.new_get(endpoint)
        end

        def create_post_request payload
          GnipApi::Request.new_post(endpoint, payload)
        end
        
        def create_delete_request payload
          delete_url = endpoint
          delete_url.query = '_method=delete'
          GnipApi::Request.new_delete(delete_url, payload)
        end

      end
    end
  end
end
