module GnipApi
  class Configuration
    attr_accessor :user, :password, :adapter_class, :account, :logger, :source, :label, :request_timeout

    def initialize
      @adapter_class = GnipApi::Adapters::HTTPartyAdapter
      @logger = Logger.new('tmp/gnip_api.log')
      @request_timeout = 60
    end
  end
end
