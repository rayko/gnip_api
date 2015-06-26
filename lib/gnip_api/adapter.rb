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
    end

    def get request
      log_request(request)
      response = adapter.get(request)
      check_response_for_errors(response)
      return true
    end

    def post request
      log_request(request)
      response = adapter.post(request)
      check_response_for_errors(response)
      return true
    end

    def delete request
      log_request(request)
      response = adapter.delete(request)
      check_response_for_errors(response)
      return response.body
    end

    def stream_get request
      log_request(request)
      adapter.stream_get(request) do |data|
        yield(data)
      end
    end

    def check_response_for_errors response
      if response.ok?
        @logger.info "#{response.request.method} request to #{response.request.uri} returned with status #{response.status} OK"
      else
        error_message = response.error_message
        @logger.error "#{response.method} request to #{response.uri} returned with status #{response.status} FAIL: #{error_message}"
        raise GnipApi::Errors::Adapter::RequestError.new(error_message)
      end
    end

    private
    def log_request request
      @logger.info "Starting #{request.method} request to #{request.uri}"
    end
  end
end
