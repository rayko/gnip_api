module GnipApi
  module Apis
    module PowerTrack
      class Stream
        attr_reader :adapter
        
        def initialize params = {}
          @stream = params[:stream] || GnipApi.config.label
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
              yield process_entries(@buffer.read!)
            rescue Exception => e
              puts e.class
              puts e.message
              puts e.backtrace[0..10].join("\n")
              raise e
            end
          end
        end 

        def process_entries entries
          entries.map!{|e| parse_json(e)}.compact!
          entries.map!{|e| build_message(e)}
          log_system_messages(entries)
          entries
        end

        def log_system_messages entries
          entries.select{|message| message.system_message? }.each do |system_message|
            GnipApi.logger.send(system_message.log_method, system_message.message)
          end
        end

        def build_message params
          Gnip::Message.build(params)
        end

        def parse_json json
          begin 
            GnipApi::JsonParser.new.parse json
          rescue GnipApi::Errors::JsonParser::ParseError
            nil
          end
        end

        private
        def create_request 
          GnipApi::Request.new_get(endpoint, {'Accept-Encoding' => 'gzip'})
        end

        def set_config
          raise 'MissingStream' if @stream.nil?
          @user = GnipApi.configuration.user
          @password = GnipApi.configuration.password
          @account = GnipApi.configuration.account
          @adapter = GnipApi::Adapter.new
          @buffer = GnipApi::Apis::PowerTrack::Buffer.new
        end

        def endpoint
          GnipApi::Endpoints.powertrack_stream(@stream)
        end

      end
    end
  end
end
