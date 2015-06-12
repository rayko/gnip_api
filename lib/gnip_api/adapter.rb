module GnipApi
  class Adapter
    attr_reader :adapter

    def initialize
      @adapter = DevAdapter.new # GnipApi.configuration.adapter_class.new
    end

    def get url
      DevAdapter.get url
    end

    def post url, payload
      DevAdapter.post url, payload
    end

    def stream_get url
      DevAdapter.stream_get url do |data|
        yield(data)
      end
    end
  end

  class DevAdapter
    class << self
      def post url, payload
        binding.pry
        HTTParty.post url, :basic_auth => auth, :body => payload
      end

      def stream_get url
        HTTParty.get url, :basic_auth => auth do |data|
          yield(data)
        end
      end

      def get url
        HTTParty.get url, :basic_auth => auth
      end

      def auth
        {
          :username => GnipApi.configuration.user, 
          :password => GnipApi.configuration.password
        }
      end
    end
  end
end
