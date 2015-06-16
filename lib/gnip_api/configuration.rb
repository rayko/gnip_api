module GnipApi
  class Configuration
    attr_accessor :user, :password, :adapter_class, :account, :logger, :mutex, :rate_limiter

    def initialize
      @adapter_class = GnipApi::Adapters::HTTPartyAdapter
      @logger = Logger.new('tmp/gnip_api.log')
      @mutex = Mutex.new
      @rate_limiter = GnipApi::RateLimiter.new
    end
  end
end
