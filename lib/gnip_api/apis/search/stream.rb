module GnipApi
  module Apis
    module Search
      class Stream
        attr_accessor :query, :label

        def initialize options={}
          @query = options[:query]
          @label = options[:label]
          @adapter = GnipApi::Adapter.new
        end

        def perform
          response = @adapter.post search_url, @query.to_json
          Result.new response
        end

        private

        def search_url
          GnipApi::Endpoints.search_stream(@label)
        end
      end
    end
  end
end
