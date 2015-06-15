module GnipApi
  class Response
    attr_reader :body, :headers, :status
    
    def initialize status, body, headers
      @status = status
      @body = body
      @headers = headers
    end

    def ok?
      @status == 200
    end
  end
end
