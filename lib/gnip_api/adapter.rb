module GnipApi
  class Adapter
    attr_reader :adapter

    def initialize
      raise GnipApi::Errors::MissingCredentials unless GnipApi.credentials?
      raise GnipApi::Errors::MissingAdapter unless GnipApi.adapter_class?
      @adapter = GnipApi.config.adapter_class.new
      @logger = GnipApi.config.logger
    end

    def get request
      log_request(request, 'GET')
      response = adapter.get(request)
      log_response(response, request.uri, 'GET')
      return response.body
    end

    def post request
      log_request(request, 'POST')
      response = adapter.post(request)
      log_response(response, request.uri, 'POST')
      return response.body
    end

    def delete request
      log_request(request, 'DELETE')
      response = adapter.delete(request)
      log_response(response, request.uri, 'DELETE')
      return response.body
    end

    def stream_get request
      log_request(request, 'GET')
      adapter.stream_get(request) do |data|
        yield(data)
      end
    end

    private
    def log_request request, method
      @logger.info "Starting #{method} request to #{request.uri}"
    end
    
    def log_response response, uri, method
      @logger.info "#{method} request to #{uri} got status #{response.status}"
    end

    def check_response response
      return true
    end
  end
end
