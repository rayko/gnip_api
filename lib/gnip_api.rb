require "gnip_api/version"
require "gnip_api/configuration"
require "gnip_api/endpoints"
require "gnip_api/apis/power_track/stream"
require "gnip_api/apis/power_track/rules"
require "gnip_api/apis/power_track/buffer"
require "gnip_api/gnip/message"
require "gnip_api/gnip/actor"
require "gnip_api/adapter"
require "gnip_api/adapters/httparty_adapter"

# External
require 'httparty'
require 'json'
require 'logger'
require 'uri'


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
