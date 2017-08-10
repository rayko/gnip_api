module GnipApi
  class Adapter
    GET = 'GET'
    POST = 'POST'
    DELETE = 'DELETE'

    attr_reader :logger, :debug

    def initialize
      raise GnipApi::Errors::MissingCredentials unless GnipApi.credentials?
      @logger = GnipApi.config.logger
      @debug = GnipApi.config.debug
    end

    def get request
      request.log!
      if debug
        data = HTTParty.get request.uri, :basic_auth => auth, :timeout => default_timeout
      else
        data = HTTParty.get request.uri, :basic_auth => auth, :timeout => default_timeout, :debug_output => @logger
      end
      response = create_response(request, data.code, data.body, data.headers)
      response.check_for_errors!
      return response.body unless response.body.empty?
      return true
    end

    def post request
      request.log!
      if debug
        data = HTTParty.post request.uri, :basic_auth => auth, :body => request.payload, :timeout => default_timeout, :debug_output => @logger
      else
        data = HTTParty.post request.uri, :basic_auth => auth, :body => request.payload, :timeout => default_timeout
      end
      response = create_response(request, data.code, data.body, data.headers)
      response.check_for_errors!
      return response.body unless response.body.empty?
      return true
    end

    def delete request
      request.log!
      if debug
        data = HTTParty.post request.uri, :basic_auth => auth, :body => request.payload, :timeout => default_timeout, :debug_output => @logger
      else
        data = HTTParty.post request.uri, :basic_auth => auth, :body => request.payload, :timeout => default_timeout
      end
      response = create_response(request, data.code, data.body, data.headers)
      response.check_for_errors!
      return response.body unless response.body.empty?
      return true
    end

    def stream_get request
      request.log!
      begin
        HTTParty.get request.uri, :headers => request.headers, :stream_body => true, :basic_auth => auth do |data|
          yield(data)
        end
      rescue Zlib::BufError => error
        GnipApi.config.logger.error "STREAM ERROR -> #{error.class} -- #{error.message}\n" + error.backtrace.join("\n")
        raise error
      end
    end

    private
    def auth
      {
        :username => username,
        :password => password
      }
    end

    def username
      GnipApi.configuration.user
    end

    def password
      GnipApi.configuration.password
    end

    def default_timeout
      GnipApi.configuration.request_timeout
    end

    def create_response request, status, body, headers
      GnipApi::Response.new request, status, body, headers
    end

  end
end
