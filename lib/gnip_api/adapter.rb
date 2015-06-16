module GnipApi
  class Adapter
    attr_reader :adapter

    def initialize
      raise GnipApi::Errors::MissingCredentials unless GnipApi.credentials?
      raise GnipApi::Errors::MissingAdapter unless GnipApi.adapter_class?
      @adapter = GnipApi.configuration.adapter_class.new
    end

    def get request
      response = adapter.get(request)
      return response.body
    end

    def post request
      response = adapter.post(request)
      return response.body
    end

    def delete request
      response = adapter.delete(request)
      return response.body
    end

    def stream_get request
      adapter.stream_get(request) do |data|
        yield(data)
      end
    end

    private
    def check_response response
      return true
    end
  end
end
