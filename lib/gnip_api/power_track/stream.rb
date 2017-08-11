module GnipApi
  module PowerTrack
    class Stream
      def initialize
        @user = GnipApi.configuration.user
        @password = GnipApi.configuration.password
        @account = GnipApi.configuration.account
        @adapter = GnipApi::Adapter.new
        @buffer = GnipApi::PowerTrack::Buffer.new
        @running = false
      end

      def logger
        GnipApi.logger
      end

      # Consumes the stream using a streamer thread instead of a simple block.
      # This way the streamer can fill in the buffer and the block consumes it periodically.
      def thread_consume
        streamer = Thread.new do
          logger.info "Starting streamer Thread"
          begin
            read_stream
          ensure
            logger.warn "Streamer exited"
          end
        end

        begin
          loop do
            logger.warn "Streamer is down" unless streamer.alive?
            raise GnipApi::Errors::PowerTrack::StreamDown unless streamer.alive?
            entries = @buffer.read!
            entries.any? ? yield(process_entries(entries)) : sleep(0.1)
          end
        ensure
          streamer.kill if streamer.alive?
        end
      end

      def consume
        read_stream do |data|
          yield(process_entries(data))
        end
      end 

      def consume_raw
        read_stream do |data|
          yield(data)
        end
      end 

      def consume_json
        read_stream do |data|
          yield(data.map{|item| parse_json(item)})
        end
      end

      def read_stream
        request = create_request
        logger.info "Opening PowerTrack parsed stream"
        begin
          @adapter.stream_get request do |chunk|
            stream_running!(@buffer, chunk)
            @buffer.insert! chunk
            yield @buffer.read! if block_given?
          end
        ensure
          logger.warn "Closing stream"
          @running = false
        end
      end

      def process_entries entries
        logger.debug "PowerTrack Stream: #{entries.size} items received"
        data = entries.map{|e| parse_json(e)}.compact
        data.map!{|e| build_message(e)} 
        data.select(&:system_message?).each(&:log!)
        return data
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
      def stream_running! buffer=nil, chunk=nil
        unless @running
          logger.info "PowerTrack stream open"
          @running = true
        end
        raise GnipApi::Errors::PowerTrack::BufferTooBig if buffer.over_limit?
        logger.warn "PowerTrack Stream: Buffer size is growing too big (slow consuming)" if buffer.size > 65536
        logger.debug "PowerTrack Stream: Received chunk of #{chunk.size} bytes" if chunk
        logger.debug "PowerTrack Stream: #{buffer.size} bytes in buffer" if buffer
      end

      def create_request 
        headers = {}
        headers['Accept-Encoding'] = 'gzip' if GnipApi.config.enable_gzip
        headers['Accept-Encoding'] ||= 'json'
        GnipApi::Request.new_get(endpoint, headers)
      end

      def endpoint
        GnipApi::Endpoints.powertrack_stream
      end

    end
  end
end
