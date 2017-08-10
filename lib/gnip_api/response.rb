module GnipApi
  class Response
    # List of codes that are considered OK
    OK_STATUSES = [200, 201, 202, 203, 204, 205, 206, 207, 208, 226]

    attr_reader :body, :headers, :status, :request
    
    def initialize request, status, body, headers
      @status = status
      @body = body
      @headers = headers
      @request = request
    end

    def request_method
      @request.request_method
    end

    def request_uri
      @request.uri
    end

    def ok?
      OK_STATUSES.include? @status
    end

    def error_message
      if @body && !@body.empty?
        parsed = GnipApi::JsonParser.new.parse(@body)
        return parsed
      end
      return nil
    end

    def check_for_errors!
      if ok?
        GnipApi.logger.info "#{request_method} request to #{request_uri} returned with status #{status} OK"
        GnipApi.logger.debug "Headers -> #{headers.inspect}"
        GnipApi.logger.debug "Body -> #{body.inspect}"
        GnipApi.logger.debug "Request headers -> #{request.headers.inspect}"
        GnipApi.logger.debug "Request payload -> #{request.payload.inspect}"
      else
        error_message = error_message
        GnipApi.logger.error "#{request_method} request to #{request_uri} returned with status #{status} FAIL"
        GnipApi.logger.debug "Headers -> #{headers.inspect}"
        GnipApi.logger.debug "Body -> #{body.inspect}"
        GnipApi.logger.debug "Request headers -> #{request.headers.inspect}"
        GnipApi.logger.debug "Request payload -> #{request.payload.inspect}"
        raise GnipApi::Errors::Adapter::GnipSoftwareError.new error_message if status == 503
        raise GnipApi::Errors::Adapter::RateLimitError.new error_message if status == 429
        raise GnipApi::Errors::Adapter::RequestError.new("Status #{status} #{error_message}")
      end
    end

  end
end
