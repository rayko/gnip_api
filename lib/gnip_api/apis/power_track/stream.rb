module GnipApi
  module Apis
    module PowerTrack
      class Stream
        attr_reader :system_messages, :adapter
        
        def initialize params = {}
          @user = GnipApi.configuration.user
          @password = GnipApi.configuration.password
          @account = GnipApi.configuration.account
          @stream = params[:stream]
          @source = params[:source]
          @adapter = GnipApi::Adapter.new
          @system_messages = []
          @buffer = GnipApi::Apis::PowerTrack::Buffer.new
        end
        
        def logger
          GnipApi.logger
        end

        def consume
          adapter.stream_get endpoint do |chunk|
            @buffer.insert! chunk
             yield(@buffer.read!)
          end
        end

        private

        def handle message
          @system_messages << message if message.system_message?
          yield message if message.activity?
        end

        def endpoint
          GnipApi::Endpoints.powertrack_stream(@source, @stream)
        end

        def parse data
          json_parse(extract_messages(data)).map { |hash| Message.build hash }
        end

        def json_parse messages
          messages.map do |message|
            begin 
              JSON.parse message
            rescue JSON::ParserError
              nil
            end
          end.compact
        end

      end
    end
  end
end
