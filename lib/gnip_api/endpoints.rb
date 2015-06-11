module GnipApi
  class Endpoints
    class << self
      def powertrack_rules source, label
        "https://api.gnip.com:443/accounts/#{GnipApi.configuration.user}/publishers/#{source}/streams/track/#{label}/rules.json"
      end

      def powertrack_stream source, label
        "https://stream.gnip.com:443/accounts/#{GnipApi.configuration.user}/publishers/#{source}/streams/track/#{label}.json"
      end
    end
  end
end
