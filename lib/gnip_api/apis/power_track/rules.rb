module GnipApi
  module Apis
    module PowerTrack
      class Rules
        attr_reader :adapter

        def initialize
          @adapter = GnipApi::Adapter.new
        end

        def list
          adapter.get GnipApi::Endpoints.powertrack_rules('twitter', 'prod')
        end
      end
    end
  end
end
