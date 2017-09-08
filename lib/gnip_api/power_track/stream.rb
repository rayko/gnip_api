module GnipApi
  module PowerTrack
    # Handles a stream connection to PowerTrack to receive the data.
    #
    # There are 3 ways to connect and consume the connection provided:
    # - :common
    # - :io
    # - :pty
    #
    # Each method uses a different backend. This is a result of experimentation
    # to mitigate disconnect issues. Each method handles differently the keep-alive
    # signals and works a bit differently at the low level.
    # The recommended method is :common, and will in the future become the default
    # once it's polished enough.
    #
    # In addition to the methods above, a third strategy using the :common method
    # is also offered to detach any processing you do on your end using threads.
    class Stream
      def initialize
        @user = GnipApi.configuration.user
        @password = GnipApi.configuration.password
        @account = GnipApi.configuration.account
        @adapter = GnipApi::Adapter.new
        @buffer = GnipApi::PowerTrack::Buffer.new
        @running = false
      end

      # Returns the configured logger.
      def logger
        GnipApi.logger
      end

      # Consumes the stream using a streamer thread instead of a simple block.
      # This way the streamer can fill in the buffer and the block consumes it periodically.
      def thread_consume
        @pool = []
        streamer = Thread.new do
          logger.info "Starting streamer Thread"
          begin
            read_stream do |items|
              items.each{|i| @pool << i}
            end
          ensure
            logger.warn "Streamer exited"
          end
        end

        begin
          loop do
            logger.warn "Streamer is down" unless streamer.alive?
            raise GnipApi::Errors::PowerTrack::StreamDown unless streamer.alive?
            entries = []
            while @pool.any?
              entries << @pool.shift
            end
            if entries.any?
              processed = process_entries(entries)
              yield(processed)
            else
              sleep(0.1)
              next
            end
          end
        ensure
          streamer.kill if streamer.alive?
        end
      end

      # The following methods are different ways of consuming the stream
      # There are 3 different methods that return data slighly different.
      # :common method uses a simple HTTParty request reading chunks and 
      # decoding the GZip. This method has a flaw that it waits for certain
      # data to be buffered by Zlib in order to return a decoded chunk.
      # :common will return chunks that may contain more than 1 objects.
      # 
      # :io method uses curl under the hood, in combination with IO.popen
      # to captrue stdout. For this method a single line is returned, which
      # would be an object sent to stream. Curl handles the GZip decoding 
      # better, however the read method for the IO buffers up the keep alive
      # signals due to not flushing STDOUT.
      #
      # :pty method is an alternative for :io in where the stdout output
      # is captured as it comes using PTY features. It almost works the 
      # same as :io, but the keep alive signals are now captured properly.
      def consume stream_method=:common
        raise ArgumentError, "Block required, non given" unless block_given?
        if stream_method == :common
          read_stream do |data|
            yield(process_entries(data))
          end
        elsif stream_method == :io
          read_io_stream do |data|
            yield(process_entries([data]))
          end
        elsif stream_method == :pty
          read_pty_stream do |data|
            yield(process_entries([data]))
          end
        else 
          raise ArgumentError, "Undefined stream method #{stream_method}"
        end
      end 

      # Similar to #consume with the difference this one spits out raw JSON
      # and has no parsing on the data received. Use it for a faster consumtion.
      # +stream_method+ param accepts the same options as #consume.
      def consume_raw stream_method=:common
        raise ArgumentError, "Block required, non given" unless block_given?
        if stream_method == :common
          read_stream do |data|
            yield(data)
          end
        elsif stream_method == :io
          read_io_stream do |data|
            yield(data)
          end
        elsif stream_method == :pty
          read_pty_stream do |data|
            yield(data)
          end
        else 
          raise ArgumentError, "Undefined stream method #{stream_method}"
        end
      end 

      # Similar to #consume but parses the JSON to Hash with no further
      # processing. +stream_method+ param accepts the same options as
      # #consume.
      def consume_json stream_method=:common
        raise ArgumentError, "Block required, non given" unless block_given?
        if stream_method == :common
          read_stream do |data|
            yield(data.map{|item| parse_json(item)})
          end
        elsif stream_method == :io
          read_io_stream do |data|
            yield(parse_json(data))
          end
        elsif stream_method == :pty
          read_pty_stream do |data|
            yield(parse_json(data))
          end
        else
          raise ArgumentError, "Undefined stream method #{stream_method}"
        end
      end

      # Opens the connection to the PowerTrack stream and returns any data
      # received using CURL IO transfer method.
      def read_io_stream
        request = create_request
        logger.info "Opening PowerTrack parsed stream"
        begin
          @adapter.io_curl_stream(request) do |data|
            yield data
          end
        ensure
          logger.warn "Closing stream"
        end
      end

      # Opens the connection to the PowerTrack stream and returns any data
      # received using CURL PTY transfer method.
      def read_pty_stream
        request = create_request
        logger.info "Opening PowerTrack parsed stream"
        begin
          @adapter.pty_curl_stream(request) do |data|
            yield data
          end
        ensure
          logger.warn "Closing stream"
        end
      end

      # Opens the connection to the PowerTrack stream and returns any data
      # received using HTTParty and standard net/http. The buffer is used
      # in this case to collect the chunks and later split them into items.
      def read_stream
        request = create_request
        logger.info "Opening PowerTrack parsed stream"
        begin
          @adapter.stream_get request do |chunk|
            @buffer.insert! chunk
            yield @buffer.read! if block_given?
          end
        ensure
          logger.warn "Closing stream"
          @running = false
        end
      end

      # Processes the items received after splitting them up, returning
      # appropiate Gnip objects.
      def process_entries entries
        logger.debug "PowerTrack Stream: #{entries.size} items received"
        data = entries.map{|e| parse_json(e)}.compact
        data.map!{|e| build_message(e)} 
        data.select(&:system_message?).each(&:log!)
        return data
      end

      # Builds a Gnip::Message object from the item params received.
      def build_message params
        Gnip::Message.build(params)
      end

      # Returns a Hash from a parsed JSON string.
      def parse_json json
        begin 
          GnipApi::JsonParser.new.parse json
        rescue GnipApi::Errors::JsonParser::ParseError
          nil
        end
      end

      private
      # Builds a GnipApi::Request with the proper data to use by the adapter.
      def create_request 
        headers = {}
        headers['accept-Encoding'] = 'gzip' if GnipApi.config.enable_gzip
        headers['accept-Encoding'] ||= 'json'
        GnipApi::Request.new_get(endpoint, headers)
      end

      # Returns the default endpoint of the stream
      def endpoint
        GnipApi::Endpoints.powertrack_stream
      end

    end
  end
end
