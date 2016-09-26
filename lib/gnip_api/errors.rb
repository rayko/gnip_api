module GnipApi
  module Errors
    module JsonParser
      class ParseError < StandardError
      end
    end

    module Adapter
      class RequestError < StandardError
        def initialize msg='Request failed'
          @message = msg
        end
      end
    end

    module PowerTrack
      class MissingRules < StandardError
        def initialize
          @message = 'No rules provided to operate'
        end
      end
    end

    module Search
      class MissingParameters < StandardError
        def initialize missing_params
          @message = "Missing required parameters: #{missing_params}"
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

module Gnip
  class UndefinedMessage < StandardError
    def initialize 
      @message = 'Could not recognize message received'
    end
  end
end
