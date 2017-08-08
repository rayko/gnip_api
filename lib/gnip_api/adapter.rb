module GnipApi
  class Adapter
    GET = 'GET'
    POST = 'POST'
    DELETE = 'DELETE'

    attr_reader :adapter

    def initialize
      raise GnipApi::Errors::MissingCredentials unless GnipApi.credentials?
      @logger = GnipApi.config.logger
      @debug = GnipApi.config.debug
    end

    def get request
      log_request(request)
      data = HTTParty.get request.uri, :basic_auth => auth, :timeout => default_timeout
      response = create_response(request, data.code, data.body, data.headers)
      check_response_for_errors(response)
      return response.body unless response.body.empty?
      return true
    end

    def post request
      log_request(request)
      data = HTTParty.post request.uri, :basic_auth => auth, :body => request.payload, :timeout => default_timeout
      response = create_response(request, data.code, data.body, data.headers)
      check_response_for_errors(response)
      return response.body unless response.body.empty?
      return true
    end

    def delete request
      log_request(request)
      data = HTTParty.post request.uri, :basic_auth => auth, :body => request.payload, :timeout => default_timeout
      response = create_response(request, data.code, data.body, data.headers)
      check_response_for_errors(response)
      return response.body unless response.body.empty?
      return true
    end

    def stream_get request
      log_request(request)
      begin
        HTTParty.get request.uri, :headers => request.headers, :stream_body => true, :basic_auth => auth do |data|
          yield(data)
        end
      rescue Zlib::BufError => error
        GnipApi.config.logger.error "STREAM ERROR -> #{error.class} -- #{error.message}\n" + error.backtrace.join("\n")
        raise error
      end
    end

    def check_response_for_errors response
      if response.ok?
        @logger.info "#{response.request_method} request to #{response.request_uri} returned with status #{response.status} OK"
      else
        error_message = response.error_message
        @logger.error "#{response.request_method} request to #{response.request_uri} returned with status #{response.status} FAIL: #{error_message}"
        raise GnipApi::Errors::Adapter::GnipSoftwareError.new error_message if response.status == 503 || response.status == '503'
        raise GnipApi::Errors::Adapter::RateLimitError.new error_message if response.status == 429 || response.status == '429'
        raise GnipApi::Errors::Adapter::RequestError.new error_message
      end
    end

    private
    def auth
      {
        :username => username,
        :password => password
      }
    end

    def log_request request
      @logger.info "Starting #{request.request_method} request to #{request.uri}"
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
