# Gnip Search Full Archive API
#
# Retrive counts with a provided rule

module GnipApi
  module Apis
    module Search
      class Counts
        attr_reader :adapter

        def initialize params={}
          @adapter = GnipApi::Adapter.new
          @label = params[:label]
        end

        def get options={}
          required_options?(options)
          payload = construct_payload(options)
          request = create_post_request(payload)
          return parse_response(adapter.post(request))
        end

        private
        def endpoint
          GnipApi::Endpoints.search_counts(@label)
        end

        def create_post_request payload
          GnipApi::Request.new_post(endpoint, payload)
        end

        def required_options
          [:rule, :to_date, :from_date]
        end

        def required_options? options
          provided_options = required_options - options.keys
          raise GnipApi::Errors::Search::MissingParameters.new(provided_options) if provided_options.any?
        end

        def parse_date date
          date.strftime('%Y%m%d%H%M')
        end

        def parse_response data
          parsed_data = JSON.parse(data)
          result_set = parsed_data['results']
          params = parsed_data['requestParameters']
          result = {:results => [], :total_count => parsed_data['totalCount'], :next => parsed_data['next'], :request_parameters => {}}
          result[:request_parameters][:bucket] = params['bucket'] if params['bucket']
          result[:request_parameters][:from_date] = Time.parse("#{params['fromDate']}-0000") if params['fromDate']
          result[:request_parameters][:to_date] = Time.parse("#{params['toDate']}-0000") if params['toDate']
          result_set.each do |item|
            result[:results] << {:time_period => Time.parse("#{item['timePeriod']}-0000"), :count => item['count']}
          end
          return result
        end

        def construct_payload options
          payload = {
            :query => options[:rule].value,
            :fromDate => parse_date(options[:from_date]),
            :toDate => parse_date(options[:to_date]),
            :maxResults => options[:max_results],
            :bucket => options[:bucket],
            :next => options[:next_token]
          }
          payload.delete_if{|k,v| v.nil?}
          return payload.to_json
        end
      end
    end
  end
end
