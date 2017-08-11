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
      options = default_options(request)
      data = HTTParty.get request.uri, options
      create_response(request, data.code, data.body, data.headers)
    end

    def post request
      options = default_options(request)
      data = HTTParty.post request.uri, options
      create_response(request, data.code, data.body, data.headers)
    end

    def delete request
      options = default_options(request)
      data = HTTParty.post request.uri, options
      create_response(request, data.code, data.body, data.headers)
    end

    def stream_get request
      request.log!
      begin
        HTTParty.get request.uri, :headers => request.headers, :stream_body => true, :basic_auth => auth do |data|
          yield(data)
        end
      rescue Zlib::BufError => error
        @logger.error "STREAM ERROR -> #{error.class} -- #{error.message}\n" + error.backtrace.join("\n")
        raise error
      end
    end

    private
    def default_options request
      {
        :headers => request.headers,
        :basic_auth => auth,
        :timeout => default_timeout,
        :debug_output => (debug ? @logger : nil),
        :body => request.payload
      }.delete_if{|k,v| v.nil? || v == ''}
    end

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
