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
          request = create_request
          rules = adapter.get(request)
          parse_rules(rules)
        end

        # Creates the specified rule. Parameters:
        # - rules: GnipApi::Apis::PowerTrack::Rule object
        def create rules
          raise 'NoRulesGiven' if rules.nil? || rules.empty?
          request = create_request(construct_rules(rules))
          adapter.post(request)
        end

        # Deletes the specified rule. Parameters:
        # - rules: GnipApi::Apis::PowerTrack::Rule object
        def delete rules
          raise "NoRulesGiven" if rules.nil? || rules.empty?
          request = create_request(construct_rules(rules))
          adapter.delete(request)
        end

        # Parses an array of GnipApi::Apis::PowerTrack::Rule objects
        # to the necesary JSON format for the endpoint
        def construct_rules rules
          parsed_rules = {:rules => []}
          rules.each do |rule|
            parsed_rules[:rules] << {:value => rule.value}
          end
          parsed_rules.to_json
        end

        def parse_rules data
          parsed_data = JSON.parse(data)
          parsed_data['rules'].map{|rule| GnipApi::Apis::PowerTrack::Rule.new(:value => rule['value'], :tag => rule['tag'])}
        end

        private
        # Where to send requests
        def endpoint
          GnipApi::Endpoints.powertrack_rules(@source, @label)
        end

        def create_request payload=nil
          GnipApi::Request.new(endpoint, payload)
        end
      end
    end
  end
end
