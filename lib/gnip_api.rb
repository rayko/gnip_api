# External
require 'httparty'
require 'yajl'
require 'logger'
require 'addressable/uri'
require 'uri'

require "gnip_api/version"
require "gnip_api/errors"
require "gnip_api/configuration"
require "gnip_api/endpoints"
require "gnip_api/apis/power_track/stream"
require "gnip_api/apis/power_track/rules"
require "gnip_api/apis/power_track/buffer"
require "gnip_api/apis/power_track/rule"
require "gnip_api/apis/search"
require "gnip_api/gnip/message"
require "gnip_api/gnip/system_message"
require "gnip_api/gnip/actor"
require "gnip_api/gnip/activity"
require "gnip_api/gnip/gnip_data"
require "gnip_api/gnip/url"
require "gnip_api/adapter"
require "gnip_api/adapters/base_adapter"
require "gnip_api/adapters/httparty_adapter"
require "gnip_api/response"
require "gnip_api/request"
require "gnip_api/json_parser"


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

    def config
      self.configuration
    end

    def credentials?
      @configuration.user && @configuration.password && @configuration.account
    end

    def adapter_class?
      @configuration.adapter_class ? true : false
    end
  end
end
