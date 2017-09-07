require 'gnip_api'
require 'pry'
require 'timecop'
require 'byebug'

def configure_gem
  GnipApi.configure do |config|
    config.user = "someone"
    config.password = "lolcat"
    config.account = "something"
    config.source = 'twitter'
    config.label = 'prod'
    config.debug = false
  end
end

def fixture_path
  Pathname.new('spec/fixtures')
end

def read_fixture path
  File.read(fixture_path.join(path))
end
