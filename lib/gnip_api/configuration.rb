module GnipApi
  class Configuration
    OUTPUT_FORMATS = [:activity, :json, :parsed_json]

    attr_accessor :user, :password, :adapter_class, :account, :logger, :source, :label, :request_timeout, :debug, 
                  :stream_output_format

    def initialize
      @adapter_class = GnipApi::Adapters::HTTPartyAdapter
      @logger = Logger.new('tmp/gnip_api.log')
      @request_timeout = 60
      @debug = false
      @stream_output_format = :activity
    end
  end
end
