module GnipApi
  class PowerTrackReplay
    def initialize
      @user = GnipApi.configuration.user
      @password = GnipApi.configuration.password
      @account = GnipApi.configuration.account
      @adapter = GnipApi::Adapter.new
      @buffer = GnipApi::PowerTrack::Buffer.new
      @running = false
      @powertrack = GnipApi::PowerTrack::Stream.new
    end

    def logger
      GnipApi.logger
    end

    def stream start_date, end_date
      @pool = []
      streamer = Thread.new do
        logger.info "Starting replay stream thread"
        begin
          read_stream(start_date, end_date) do |items|
           items.each{|i| @pool << i} 
          end
        ensure
          logger.warn "Streamer exited"
        end
      end

      begin
        loop do
          logger.warn "Streamer is down" unless streamer.alive?
          entries = []
          while @pool.any?
            entries << @pool.shift
          end
          if entries.any?
            processed = @powertrack.process_entries(entries)
            yield(processed)
            break if entries.last =~ /Replay Request Completed/
          else
            sleep(0.1)
            next
          end
        end
      ensure
        streamer.kill if streamer.alive?
      end
    end

    def read_stream start_date, end_date
      sd = start_date.utc.strftime("%Y%m%d%H%M")
      ed = end_date.utc.strftime("%Y%m%d%H%M")
      url = stream_endpoint + "?fromDate=#{sd}&toDate=#{ed}"
      headers = {'accept-Encoding' => 'json' }
      headers['accept-Encoding'] = 'gzip' if GnipApi.config.enable_gzip
      request = GnipApi::Request.new_get(url, headers)
      logger.info "Opening PowerTrack Replay parsed stream"
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

    def list
      request = GnipApi::Request.new_get(rules_endpoint)
      rules = fetch_data(request)
      GnipApi::PowerTrack::Rules.new.parse_rules(rules)
    end

    def create rules
      raise ArgumentError.new('No rules provided') if rules.nil? || rules.empty?
      payload = GnipApi::PowerTrack::Rules.new.construct_rules(rules)
      request = GnipApi::Request.new_post(rules_endpoint, payload)
      response = fetch_data(request)
      return true if response.nil?
      return GnipApi::JsonParser.new.parse(response)
    end

    def delete rules
      raise ArgumentError.new('No rules provided') if rules.nil? || rules.empty?
      delete_endpoint = rules_endpoint
      delete_endpoint.query = "_method=delete"
      payload = GnipApi::PowerTrack::Rules.new.construct_rules(rules)
      request = GnipApi::Request.new_post(delete_endpoint, payload)
      response = fetch_data(request)
      return true if response.nil?
      return GnipApi::JsonParser.new.parse(response)
    end

    private
    def fetch_data(request)
      request.execute!
    end

    def rules_endpoint
      GnipApi::Endpoints.powertrack_replay_rules
    end

    def stream_endpoint
      GnipApi::Endpoints.powertrack_replay
    end

    def validation_endpoint
      GnipApi::Endpoints.powertrack_rule_validator
    end

    def create_validation_request payload
      GnipApi::Request.new_post(validation_endpoint, payload)
    end

    def create_get_request
      GnipApi::Request.new_get(endpoint)
    end

    def create_post_request payload
      GnipApi::Request.new_post(endpoint, payload)
    end
    
    def create_delete_request payload
      delete_url = endpoint
      delete_url.query = '_method=delete'
      GnipApi::Request.new_post(delete_url, payload)
    end


  end
end
