module GnipApi
  class Configuration
    attr_accessor :user, :password, :adapter_class, :account, :logger, :source, :label

    def initialize
      @adapter_class = GnipApi::Adapters::HTTPartyAdapter
      @logger = Logger.new('tmp/gnip_api.log')
    end
  end
end
