module GnipApi
  module Adapters
    class HTTPartyAdapter < GnipApi::Adapters::BaseAdapter
      def post request
        data = HTTParty.post request.uri, :basic_auth => auth, :body => request.payload, :timeout => default_timeout
        httparty_debugger(data)
        return response(request, data)
      end
      
      def delete request
        data = HTTParty.post request.uri, :basic_auth => auth, :body => request.payload, :timeout => default_timeout
        httparty_debugger(data)
        return response(request, data)
      end
      
      def get request
        data = HTTParty.get request.uri, :basic_auth => auth, :timeout => default_timeout
        httparty_debugger(data)
        return response(request, data)
      end

      def stream_get request
        HTTParty.get request.uri, :headers => request.headers, :stream_body => true, :basic_auth => auth do |data|
          yield(data)
        end
      end

      def auth
        {
          :username => username,
          :password => password
        }
      end
      
      def response request, data
        create_response request, data.code, data.body, data.headers
      end

      private
      def debug_data data
        {
          :request_headers => data.request.instance_variable_get(:@raw_request).to_hash,
          :request_body => data.request.instance_variable_get(:@raw_request).body,
          :request_method => data.request.http_method.to_s,
          :request_url => data.request.path.to_s,
          :response_headers => data.headers,
          :response_status => data.code,
          :response_body => data.body
        }
      end

      def httparty_debugger data
        return nil unless GnipApi.config.debug
        debug_request(debug_data(data))
        return nil
      end
      
    end
  end
end
