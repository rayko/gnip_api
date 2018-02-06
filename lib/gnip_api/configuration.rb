module GnipApi
  # Configurations for the GnipApi gem.
  #
  # Defaults:
  # - logger: *Logger.new('tmp/gnip_api.log')*
  # - request_timeout: *60*
  # - debug: *false*
  # - enable_gzip: *true*
  # - log_level: *Logger::WARN*
  # - buffer_limit: *1000000*
  class Configuration
    attr_accessor :user, :password, :account, :logger, :source, :label, :request_timeout, :debug, 
                  :enable_gzip, :log_level

    def initialize
      @request_timeout = 60
      @debug = false
      @enable_gzip = true
      @log_level = Logger::WARN
    end

    def logger
      return @logger if @logger
      @logger = Logger.new('tmp/gnip_api.log')
      @logger.level = log_level
      return @logger
    end
  end
end
