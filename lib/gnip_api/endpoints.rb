module GnipApi
  class Endpoints
    class << self
      def powertrack_rules source, label
        URI("https://api.gnip.com:443/accounts/#{account}/publishers/#{source}/streams/track/#{label}/rules.json")
      end

      def powertrack_stream source, label
        URI("https://stream.gnip.com:443/accounts/#{account}/publishers/#{source}/streams/track/#{label}.json")
      end

      def search_stream label
        URI("https://search.gnip.com/accounts/#{account}/search/#{label}.json")
      end
      
      def search_count
        URI("https://search.gnip.com/accounts/#{ CONFIG['account'] }/search/#{label}.json/counts")
      end

      private
      def account
        GnipApi.configuration.account
      end
    end
  end
end
