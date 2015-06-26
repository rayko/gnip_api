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
        parsed = JSON.parse(@body)
        return parsed['error']['message'] if parsed['error']
      end
      return nil
    end
  end
end
