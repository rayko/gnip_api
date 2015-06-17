module GnipApi
  module Apis
    module PowerTrack
      class Stream
        attr_reader :system_messages, :adapter
        
        def initialize params = {}
          @stream = params[:stream]
          @source = params[:source]
          set_config
        end
        
        def logger
          GnipApi.logger
        end

        def consume
          request = create_request
          adapter.stream_get request do |chunk|
            @buffer.insert! chunk
             yield(@buffer.read!)
          end
        end

        private

        def create_request 
          GnipApi::Request.new_get(endpoint)
        end

        def set_config
          @user = GnipApi.configuration.user
          @password = GnipApi.configuration.password
          @account = GnipApi.configuration.account
          @adapter = GnipApi::Adapter.new
          @buffer = GnipApi::Apis::PowerTrack::Buffer.new
        end

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
