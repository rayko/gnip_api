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
            begin
              yield @buffer.read!.map{ |entrie| handle_message(entrie) }
            rescue Exception => e
              puts e.class
              puts e.message
              puts e.backtrace[0..5].join("\n")
              raise e
            end
          end
        end 

        def handle_message json
          parsed = parse_json(json)
          if parsed
            return Gnip::Message.build(parsed)
          else
            return json
          end
        end

        def parse_json json
          begin 
            JSON.parse json
          rescue JSON::ParserError
            nil
          end
        end

        private
        def create_request 
          GnipApi::Request.new_get(endpoint, {'Accept-Encoding' => 'gzip'})
        end

        def set_config
          raise 'MissingStream' if @stream.nil?
          raise 'MissingSource' if @source.nil?
          @user = GnipApi.configuration.user
          @password = GnipApi.configuration.password
          @account = GnipApi.configuration.account
          @adapter = GnipApi::Adapter.new
          @buffer = GnipApi::Apis::PowerTrack::Buffer.new
        end

        def endpoint
          GnipApi::Endpoints.powertrack_stream(@source, @stream)
        end

        def parse data
          json_parse(extract_messages(data)).map { |hash| Message.build hash }
        end


      end
    end
  end
end
