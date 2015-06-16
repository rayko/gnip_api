module GnipApi
  module Limiters
    module Rules

      def rules_init
        @rules_last_reset = Time.now
        @rules_requests = 0
      end
      
      def rules_request_allowed?
        mutex.synchronize do
          reset_rules_if_expired!
          add_rules_request!
          return true if @rules_requests <= rules_max_requests
          return false
        end
      end
      
      def reset_rules_if_expired!
        if seconds_since_last_rules_request >= rules_expire
          reset_rules!
        end
      end
      
      def seconds_since_last_rules_request
        Time.now.to_i - @rules_last_reset.to_i
      end
      
      def add_rules_request!
        @rules_requests += 1
      end
      
      def reset_rules!
        @rules_last_reset = Time.now
        @rules_requests = 0
      end
      
      def rules_last_reset
        @rules_last_reset
      end
      
      def rules_requests
        @rules_requests
      end
      
      def rules_max_requests
        5
      end
      
      def rules_expire
        1
      end

    end
  end
end
