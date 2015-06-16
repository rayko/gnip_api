module GnipApi
  class RateLimiter
    include GnipApi::Limiters::Rules
    
    def initialize
      self.rules_init
    end

    private
    def mutex
      GnipApi.config.mutex
    end
  end
end
