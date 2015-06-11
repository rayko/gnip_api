module GnipApi
  module Apis
    module PowerTrack
      class Consumer
        attr_reader :system_messages
        
        def initialize params = {}
          @user = GnipApi.configuration.user
          @password = GnipApi.configuration.password
          @account = GnipApi.configuration.account
          @stream = params[:stream]
          @source = params[:source]
          @system_messages = []
        end
        
        def logger
          GnipApi.logger
        end

        def run! &b
          logger.info 'Establishing connection.'
          response = HTTParty.get track_endpoint, basic_auth: auth do |data|
            begin
              logger.info "Receiving data: #{ data.size } bytes."
              parse(data).each { |message| handle(message, &b) }
            rescue Exception => e
              logger.error e
            end
          end
          logger.info "Connection ended. response: #{ response }"
        end

        private

        def handle message
          @system_messages << message if message.system_message?
          yield message if message.activity?
        end

        def track_endpoint
          GnipApi::Endpoints.powertrack_stream(@source, @stream)
        end

        def parse data
          json_parse(extract_messages(data)).map { |hash| Message.build hash }
        end

        # Adds data chunk to buffer and returns array of complete messages
        def extract_messages data
          @buffer ||= ""
          @buffer << data
          messages = @buffer.split("\r\n")[0..-2]
          unless messages.empty?
            size = messages.map(&:size).reduce(:+) + messages.size * 2
            @buffer[0..size-1] = ''
          end
          messages
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

        def logger
          self.class.logger
        end

        def auth
          { username: @user, password: @pass }
        end
      end
    end
  end
end
