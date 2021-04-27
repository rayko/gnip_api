# Gnip PowerTrack Rules API
#
# Create, delete and list rules of a powetrack stream.

module GnipApi
  module PowerTrack
    class Rules
      # Returns an array of defined rules
      def list
        request = create_get_request
        rules = fetch_data(request)
        parse_rules(rules)
      end

      # Creates the specified rule. Parameters:
      # - rules: GnipApi::PowerTrack::Rule object
      def create rules
        raise ArgumentError.new('No rules provided') if rules.nil? || rules.empty?
        request = create_post_request(construct_rules(rules))
        response = fetch_data(request)
        return true if response.nil?
        return GnipApi::JsonParser.new.parse(response)
      end

      # Deletes the specified rule. Parameters:
      # - rules: GnipApi::PowerTrack::Rule object
      def delete rules
        raise ArgumentError.new('No rules provided') if rules.nil? || rules.empty?
        request = create_delete_request(construct_rules(rules))
        response = fetch_data(request)
        return true if response.nil?
        return GnipApi::JsonParser.new.parse(response)
      end

      def get_by_id rule_id
        raise ArgumentError.new('No rule provided') if rule_id.nil?
        special_endpoint = URI(endpoint.to_s.gsub('.json', '')) # Minihack
        request = GnipApi::Request.new_get("#{special_endpoint}/rules/#{rule_id}.json")
        response = fetch_data(request)
        parse_rules(response).first
      end

      def get_by_ids rule_ids
        raise ArgumentError.new('No rule provided') if rule_ids.nil? || rule_ids.empty?
        special_endpoint = URI("#{endpoint}?_method=get")
        payload = { rule_ids: rule_ids }.to_json
        request = GnipApi::Request.new_post(special_endpoint, payload)
        response = fetch_data(request)
        parse_rules(response)
      end

      def delete_by_ids rule_ids
        raise ArgumentError.new('No rules provided') if rule_ids.nil? || rule_ids.empty?
        request = create_delete_request({ rule_ids: rule_ids }.to_json)
        response = fetch_data(request)
        return true if response.nil?
        return GnipApi::JsonParser.new.parse(response)
      end

      def validate rules
        raise ArgumentError.new('No rules provided') if rules.nil? || rules.empty?
        request = create_validation_request(construct_rules(rules))
        response = fetch_data(request)
        return true if response.nil?
        return GnipApi::JsonParser.new.parse(response)
      end

      # Parses an array of GnipApi::PowerTrack::Rule objects
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
        parsed_data['rules'].map{|rule| GnipApi::PowerTrack::Rule.new(:value => rule['value'], :tag => rule['tag'], :id => rule['id'])}
      end

      private
      def fetch_data(request)
        request.execute!
      end

      def endpoint
        GnipApi::Endpoints.powertrack_rules
      end

      def validation_endpoint
        GnipApi::Endpoints.powertrack_rule_validator
      end

      def create_validation_request payload
        GnipApi::Request.new_post(validation_endpoint, payload)
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
        GnipApi::Request.new_post(delete_url, payload)
      end

    end
  end
end
