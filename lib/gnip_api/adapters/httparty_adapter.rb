module GnipApi
  module Adapters
    class HTTPartyAdapter < GnipApi::Adapters::BaseAdapter
      def post request
        data = HTTParty.post request.uri, :basic_auth => auth, :body => request.payload
        return response(data)
      end
      
      def delete request
        data = HTTParty.delete request.uri, :basic_auth => auth, :body => request.payload
        return response(data)
      end
      
      def get request
        data = HTTParty.get request.uri, :basic_auth => auth
        return response(data)
      end

      def stream_get request
        HTTParty.get request.uri, :basic_auth => auth do |data|
          yield(data)
        end
      end

      def auth
        {
          :username => username,
          :password => password
        }
      end
      
      def response data
        create_response data.code, data.body, data.headers
      end
      
    end
  end
end
