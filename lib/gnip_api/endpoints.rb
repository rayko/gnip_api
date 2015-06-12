module GnipApi
  class Endpoints
    class << self
      def powertrack_rules source, label
        URI("https://api.gnip.com:443/accounts/#{GnipApi.configuration.account}/publishers/#{source}/streams/track/#{label}/rules.json")
      end

      def powertrack_stream source, label
        URI("https://stream.gnip.com:443/accounts/#{GnipApi.configuration.account}/publishers/#{source}/streams/track/#{label}.json")
      end
    end
  end
end
