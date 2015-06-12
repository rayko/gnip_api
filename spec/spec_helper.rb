require 'gnip_api'

def configure_gem
  GnipApi.configure do |config|
    config.user = "someone"
    config.password = "lolcat"
    config.account = "something"
  end
end
