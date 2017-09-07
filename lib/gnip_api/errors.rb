module GnipApi
  module Errors
    module Configuration
      class InvalidOutputFormat < StandardError
        def initialize msg="Invalid output format. Available formats: #{GnipApi::Configuration::OUTPUT_FORMATS}"
          @message = msg
        end
      end
    end

    module JsonParser
      class ParseError < StandardError
      end
    end

    module Adapter
      class RequestError < StandardError; end

      class RateLimitError < StandardError
        def initialize msg='Exceded rate limits'
          @message = msg
        end
      end

      class GnipSoftwareError < StandardError
        def initialize msg='Gnip Software Error'
          @message = msg
        end
      end
    end

    module PowerTrack
      class StreamDown < StandardError; end

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
