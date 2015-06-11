module GnipApi
  class Adapter
    attr_reader :adapter

    def initialize
      @adapter = DevAdapter.new # GnipApi.configuration.adapter_class.new
    end

    def get url
      DevAdapter.get url
    end

    def stream_get url
      DevAdapter.stream_get url do |data|
        yield(data)
      end
    end
  end

  class DevAdapter
    class << self
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
