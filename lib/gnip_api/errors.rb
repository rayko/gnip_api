module GnipApi
  module Errors
    module Configuration
      class InvalidOutputFormat < StandardError
        def initialize msg="Invalid output format. Available formats: #{GnipApi::Configuration::OUTPUT_FORMATS}"
          super msg
        end
      end
    end

    module JsonParser
      class ParseError < StandardError; end
    end

    module Adapter
      class RequestError < StandardError; end
      class InvalidInput < StandardError; end

      class RateLimitError < StandardError
        def initialize msg='Exceded rate limits'
          super msg
        end
      end

      class GnipSoftwareError < StandardError
        def initialize msg='Gnip Software Error'
          super msg
        end
      end
    end

    module PowerTrack
      class StreamDown < StandardError; end

      class MissingRules < StandardError
        def initialize
          super 'No rules provided to operate'
        end
      end
    end

    module Search
      class MissingParameters < StandardError
        def initialize missing_params
          super "Missing required parameters: #{missing_params}"
        end
      end
    end

    class MissingCredentials < StandardError
      def initialize
        super 'No credentials provided'
      end
    end
    
    class MissingAdapter < StandardError
      def initialize
        super 'No adapter selected'
      end
    end
  end
end

module Gnip
  class UndefinedMessage < StandardError
    def initialize 
      super 'Could not recognize message received'
    end
  end
end
