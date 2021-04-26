# External
require 'httparty'
require 'yajl'
require 'logger'
require 'addressable/uri'
require 'uri'
require 'pty'

require 'gnip_api/version'
require 'gnip_api/errors'
require 'gnip_api/configuration'
require 'gnip_api/endpoints'
require 'gnip_api/power_track/stream'
require 'gnip_api/power_track/rules'
require 'gnip_api/power_track/buffer'
require 'gnip_api/power_track/rule'
require 'gnip_api/power_track_replay'
require 'gnip_api/search'
require 'gnip_api/gnip/message'
require 'gnip_api/gnip/system_message'
require 'gnip_api/gnip/twitter_compliance_message'
require 'gnip_api/gnip/actor'
require 'gnip_api/gnip/activity'
require 'gnip_api/gnip/gnip_data'
require 'gnip_api/gnip/url'
require 'gnip_api/adapter'
require 'gnip_api/response'
require 'gnip_api/request'
require 'gnip_api/json_parser'
require 'gnip_api/usage'

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

    def deprecation_warning old_method, new_method, file_caller, reason = nil
      message = "[DEPRECATION] `#{old_method}` will be removed in the future, use `#{new_method}` instead. "
      message += "Reason: #{reason}. " if reason
      message += "Called from: #{file_caller}"
      warn(message)
    end
  end
end
