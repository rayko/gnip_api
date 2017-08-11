# Gnip Search Full Archive API
#
# Retrive counts with a provided rule

module GnipApi
  class Search
    def activities options={}
      required_options?(options)
      payload = construct_activities_payload(options)
      request = GnipApi::Request.new_post(activities_endpoint, payload)
      data = fetch_data(request)
      return parse_activities_response(data)
    end

    def counts options={}
      required_options?(options)
      payload = construct_counts_payload(options)
      request = GnipApi::Request.new_post(count_endpoint, payload)
      data = fetch_data(request)
      return parse_counts_response(data)
    end

    private
    def fetch_data(request)
      request.execute!
    end

    def count_endpoint
      GnipApi::Endpoints.search_counts
    end

    def activities_endpoint
      GnipApi::Endpoints.search_activities
    end

    def required_options
      [:rule]
    end

    def required_options? options
      provided_options = required_options - options.keys
      raise GnipApi::Errors::Search::MissingParameters.new(provided_options) if provided_options.any?
    end

    def parse_date date
      return nil unless date
      date.strftime('%Y%m%d%H%M')
    end

    def parse_counts_response data
      parsed_data = GnipApi::JsonParser.new.parse(data)
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

    def parse_activities_response data
      parsed_data = GnipApi::JsonParser.new.parse(data)
      result_set = parsed_data['results']
      params = parsed_data['requestParameters']
      result = {:results => [], :next => parsed_data['next'], :request_parameters => {}}
      result[:request_parameters][:bucket] = params['bucket'] if params['bucket']
      result[:request_parameters][:from_date] = Time.parse("#{params['fromDate']}-0000") if params['fromDate']
      result[:request_parameters][:to_date] = Time.parse("#{params['toDate']}-0000") if params['toDate']
      result[:request_parameters][:max_results] = params['maxResults'] if params['maxResult']
      result_set.each do |item|
        result[:results] << Gnip::Activity.new(item)
      end
      return result
    end

    def construct_counts_payload options
      payload = {
        :query => options[:rule].value,
        :fromDate => parse_date(options[:from_date]),
        :toDate => parse_date(options[:to_date]),
        :bucket => options[:bucket],
        :next => options[:next_token]
      }
      payload.delete_if{|k,v| v.nil?}
      return payload.to_json
    end

    def construct_activities_payload options
      payload = {
        :query => options[:rule].value,
        :fromDate => parse_date(options[:from_date]),
        :toDate => parse_date(options[:to_date]),
        :tag => options[:rule].tag,
        :maxResults => options[:max_results],
        :next => options[:next_token]
      }
      payload.delete_if{|k,v| v.nil?}
      return payload.to_json
    end
  end
end

