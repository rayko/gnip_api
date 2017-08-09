module GnipApi
  class Configuration
    attr_accessor :user, :password, :account, :logger, :source, :label, :request_timeout, :debug, 
                  :enable_gzip, :log_level, :buffer_limit

    def initialize
      @logger = Logger.new('tmp/gnip_api.log')
      @request_timeout = 60
      @debug = false
      @enable_gzip = true
      @log_level = Logger::INFO
      @logger.level = @log_level
    end
  end
end
