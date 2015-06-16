module GnipApi
  module Errors
    module PowerTrack
      class MissingRules < StandardError
        def initialize
          @message = 'No rules provided to operate'
        end
      end
    end

    class MissingCredentials < StandardError
      def initialize
        @message = 'No credentials provided'
      end
    end
    
    class MissingAdapter < StandardError
      def initialize
        @message = 'No adapter selected'
      end
    end
  end
end