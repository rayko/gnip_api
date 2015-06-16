require 'gnip_api'
require 'pry'
require 'lib/test_adapter.rb'
require 'timecop'

def configure_gem
  GnipApi.configure do |config|
    config.user = "someone"
    config.password = "lolcat"
    config.account = "something"
    config.adapter_class = TestAdapter
  end
end
