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
      @logger = Logger.new('tmp/gnip_api.log')
      @request_timeout = 60
      @debug = false
      @enable_gzip = true

      @log_level = Logger::WARN
      @logger.level = @log_level
    end
  end
end
