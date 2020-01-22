# Usage endpoint to measure API usage.

module GnipApi
  class Usage

    # Options:
    # :buckcet -> 'month'|'day'
    # :from_date -> DateTime
    # :to_date -> DateTime
    def get options={}
      url_params = construct_payload(options)
      request = GnipApi::Request.new_get(url(url_params))
      data = fetch_data(request)
      return parse_response(data)
    end

    private

    def fetch_data(request)
      request.execute!
    end

    def endpoint
      GnipApi::Endpoints.usage
    end

    def parse_date date
      return nil unless date
      date.strftime('%Y%m%d%H%M')
    end

    def parse_response data
      parsed_data = GnipApi::JsonParser.new.parse(data)
      return parsed_data
    end

    def url params
      uri = endpoint
      uri.query = URI.encode_www_form(params)
      uri
    end

    def construct_payload options
      payload = {
        bucket: options[:bucket],
        fromDate: parse_date(options[:from_date]),
        toDate: parse_date(options[:to_date])
      }
      payload.delete_if{|k,v| v.nil?}
      payload
    end
  end
end

