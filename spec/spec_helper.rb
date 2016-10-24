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
    config.source = 'twitter'
    config.label = 'prod'
    config.debug = false
    config.stream_output_format = :activity
  end
end

def fixture_path
  Pathname.new('spec/fixtures')
end
