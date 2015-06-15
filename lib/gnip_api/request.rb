module GnipApi
  class Request
    attr_reader :uri, :payload, :headers

    def initialize uri, payload=nil, headers=nil
      @uri = uri
      @payload = payload
      @headers = headers
    end
  end
end
