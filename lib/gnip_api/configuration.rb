module GnipApi
  class Configuration
    OUTPUT_FORMATS = [:activity, :json, :parsed_json]

    attr_accessor :user, :password, :account, :logger, :source, :label, :request_timeout, :debug, 
                  :stream_output_format, :enable_gzip, :log_level

    def initialize
      @logger = Logger.new('tmp/gnip_api.log')
      @request_timeout = 60
      @debug = false
      @stream_output_format = :activity
      @enable_gzip = true
      @log_level = Logger::INFO
      @logger.level = @log_level
    end
  end
end
