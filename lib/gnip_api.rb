require "gnip_api/version"
require "gnip_api/configuration"
require "gnip_api/endpoints"
require "gnip_api/apis/power_track/consumer"
require "gnip_api/gnip/message"
require "gnip_api/gnip/actor"

# External
require 'httparty'
require 'json'
require 'logger'


module GnipApi
  class << self
    attr_reader :configuration

    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
      self.configuration
    end

    def logger
      self.configuration.logger
    end
  end
end
