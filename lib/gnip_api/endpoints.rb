module GnipApi
  class Endpoints
    class << self
      def powertrack_rules label
        URI("https://gnip-api.twitter.com/rules/powertrack/accounts/#{account}/publishers/twitter/#{label}.json")
      end

      def powertrack_stream label
        URI("https://gnip-stream.twitter.com/stream/powertrack/accounts/#{account}/publishers/twitter/#{label}.json")
      end

      def powertrack_rule_validator label
        URI("https://gnip-api.twitter.com/rules/powertrack/accounts/#{account}/publishers/twitter/#{label}/validation.json")
      end

      def powertrack_stream_replay label
        URI("https://gnip-stream.twitter.com/replay/powertrack/accounts/#{account}/publishers/twitter/#{label}.json")
      end

      def powertrack_rule_replay label
        URI("https://gnip-api.twitter.com/rules/powertrack-replay/accounts/#{account}/publishers/twitter/#{label}.json")
      end

      def search_activities label
        URI("https://gnip-api.twitter.com/search/fullarchive/accounts/#{account}/#{label}.json")
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
