module GnipApi
  class Endpoints
    class << self
      def powertrack_replay
        URI("https://gnip-stream.gnip.com/replay/powertrack/accounts/#{account}/publishers/twitter/#{label}.json")
      end

      def powertrack_replay_rules
        URI("https://gnip-api.twitter.com/rules/powertrack-replay/accounts/#{account}/publishers/twitter/#{label}.json")
      end

      def powertrack_rule_validator
        URI("https://gnip-api.twitter.com/rules/powertrack/accounts/#{account}/publishers/twitter/#{label}/validation.json")
      end

      def powertrack_rules
        URI("https://gnip-api.twitter.com/rules/powertrack/accounts/#{account}/publishers/twitter/#{label}.json")
      end

      def powertrack_stream
        URI("https://gnip-stream.twitter.com/stream/powertrack/accounts/#{account}/publishers/twitter/#{label}.json")
      end

      def powertrack_rule_validator
        URI("https://gnip-api.twitter.com/rules/powertrack/accounts/#{account}/publishers/twitter/#{label}/validation.json")
      end

      def powertrack_stream_replay
        URI("https://gnip-stream.twitter.com/replay/powertrack/accounts/#{account}/publishers/twitter/#{label}.json")
      end

      def powertrack_rule_replay
        URI("https://gnip-api.twitter.com/rules/powertrack-replay/accounts/#{account}/publishers/twitter/#{label}.json")
      end

      def search_activities
        URI("https://gnip-api.twitter.com/search/fullarchive/accounts/#{account}/#{label}.json")
      end
      
      def search_counts
        URI("https://gnip-api.twitter.com/search/fullarchive/accounts/#{account}/#{label}/counts.json")
      end

      private
      def account
        GnipApi.configuration.account
      end

      def label
        GnipApi.configuration.label
      end
    end
  end
end
