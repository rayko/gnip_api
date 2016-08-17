module GnipApi
  class Endpoints
    class << self
      def powertrack_rules source, label
        URI("https://api.gnip.com:443/accounts/#{account}/publishers/#{source}/streams/track/#{label}/rules.json")
      end

      def powertrack_stream source, label
        URI("https://stream.gnip.com:443/accounts/#{account}/publishers/#{source}/streams/track/#{label}.json")
      end

      def search_activities label
        URI("https://gnip-api.twitter.com/search/fullarchive/accounts/#{account}/#{label}")
      end
      
      def search_counts label
        URI("https://gnip-api.twitter.com/search/fullarchive/accounts/#{account}/#{label}/counts.json")
      end

      private
      def account
        GnipApi.configuration.account
      end
    end
  end
end
