module GnipApi
  # The interface to the world. Wraps the net adapter of choice and exposes common methods
  # for the rest of the classes to use, abstracting details of the request/response.
  # A note on the data:
  # HTTParty was selected over Excon for the simple reason that Excon doesn't handle
  # GZip responses. HTTParty uses net/http under the hood and handles this as expected.
  # However, for reasons I don't know at this point, the Zlib responsible of inflating
  # the GZip compressed data waits to fill in a buffer in order to return a decompressed
  # chunk. You can test this on a farily busy stream and you'll see that all chunks you
  # receive decompressed are almsot always 16384 bytes. Additionally, the \r\n Gnip sends
  # as a keep alive signal seems to be buffered further.
  # As a result I expose 2 additional methods for consuming the stream that uses Curl
  # instead. Curl handles the GZip data better. You can launch it in a shell and the 
  # keep alive signals are properly there.
  # These alternatives are a bit of a cheat, but allows delegation of handling the actual
  # connection and the GZip data.
  # 
  # #stream_get will work as usual, using HTTParty and Net::HTTP stuff.
  #
  # #io_curl_stream will launch a subprocess and capture output with IO.popen. This method
  # behaves similarly to #stream_get regarding the keep alive signals. However, these are
  # returned all at once when a bigger chunk of data is sent over the stream. Still, it reads
  # them well and can be handled.
  #
  # #pty_curl_stream is different. Using the PTY features, a shell is opened and the output 
  # captured is as (in my opinion) should be. All keep-alive signals are returned when received
  # with no wait at all.
  #
  # All this will remain experimental until tested on a real environment. I recomment to use
  # #stream_get which was already tested and works as expected.
  class Adapter
    GET = 'GET'
    POST = 'POST'
    DELETE = 'DELETE'

    attr_reader :logger, :debug

    def initialize
      raise GnipApi::Errors::MissingCredentials unless GnipApi.credentials?
      @logger = GnipApi.config.logger
      @debug = GnipApi.config.debug
    end

    def get request
      options = default_options(request)
      data = HTTParty.get request.uri, options
      create_response(request, data.code, data.body, data.headers)
    end

    def post request
      options = default_options(request)
      data = HTTParty.post request.uri, options
      create_response(request, data.code, data.body, data.headers)
    end

    def delete request
      options = default_options(request)
      data = HTTParty.post request.uri, options
      create_response(request, data.code, data.body, data.headers)
    end

    def stream_get request
      request.log!
      begin
        HTTParty.get request.uri, :headers => request.headers, :stream_body => true, :basic_auth => auth do |data|
          yield(data)
        end
      rescue Zlib::BufError => error
        logger.error "STREAM ERROR -> #{error.class} -- #{error.message}\n" + error.backtrace.join("\n")
        raise error
      end
    end

    def io_curl_stream request
      request.log!
      auth_header = "Authorization: Basic #{base64_auth}"
      cmd = "curl --compressed -s --header \"#{auth_header}\" \"#{request.uri}\""
      begin
        IO.popen(cmd) do |io|
          while line = io.gets.strip do
            logger.info "Keep alive received" if line == ''
            next if line == ''
            yield(line)
          end
        end
      ensure
        logger.warn "Stream closed"
      end
    end

    def pty_curl_stream request
      request.log!
      auth_header = "Authorization: Basic #{base64_auth}"
      cmd = "curl --compressed -s --header \"#{auth_header}\" \"#{request.uri}\""
      begin
        PTY.spawn(cmd) do |stdout, stdin, pid|
          begin
            stdout.each do |line|
              logger.info "Keep alive received" if line.strip == ''
              next if line.strip == ''
              yield(line.strip)
            end
          rescue Errno::EIO
          end
        end
      rescue PTY::ChildExited
        logger.warn "Stream closed"
      end
    end

    private
    def default_options request
      {
        :headers => request.headers,
        :basic_auth => auth,
        :timeout => default_timeout,
        :debug_output => (debug ? logger : nil),
        :body => request.payload
      }.delete_if{|k,v| v.nil? || v == ''}
    end

    def base64_auth
      Base64.encode64("#{auth[:username]}:#{auth[:password]}").strip
    end

    def auth
      {
        :username => username,
        :password => password
      }
    end

    def username
      GnipApi.configuration.user
    end

    def password
      GnipApi.configuration.password
    end

    def default_timeout
      GnipApi.configuration.request_timeout
    end

    def create_response request, status, body, headers
      GnipApi::Response.new request, status, body, headers
    end

  end
end
