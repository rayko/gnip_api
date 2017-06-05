module GnipApi
  class Adapter
    GET = 'GET'
    POST = 'POST'
    DELETE = 'DELETE'

    attr_reader :adapter

    def initialize
      raise GnipApi::Errors::MissingCredentials unless GnipApi.credentials?
      raise GnipApi::Errors::MissingAdapter unless GnipApi.adapter_class?
      @adapter = GnipApi.config.adapter_class.new
      @logger = GnipApi.config.logger
      @debug = GnipApi.config.debug
    end

    def get request
      log_request(request)
      response = adapter.get(request)
      check_response_for_errors(response)
      return response.body unless response.body.empty?
      return true
    end

    def post request
      log_request(request)
      response = adapter.post(request)
      check_response_for_errors(response)
      return response.body unless response.body.empty?
      return true
    end

    def delete request
      log_request(request)
      response = adapter.delete(request)
      check_response_for_errors(response)
      return response.body unless response.body.empty?
      return true
    end

    def stream_get request
      log_request(request)
      adapter.stream_get(request) do |data|
        yield(data)
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
    def log_request request
      @logger.info "Starting #{request.request_method} request to #{request.uri}"
    end
  end
end
