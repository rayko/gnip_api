module GnipApi
  class Response
    attr_reader :body, :headers, :status, :request
    
    def initialize request, status, body, headers
      @status = status
      @body = body
      @headers = headers
      @request = request
    end

    def ok?
      @status == 200
    end

    def error_message
      if @body
        parsed = JSON.parse(@body)
        return parsed['error']['message'] if parsed['error']
      end
      return nil
    end
  end
end
