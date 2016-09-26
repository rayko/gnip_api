module GnipApi
  class JsonParser
    def parse data
      begin
        return parser.parse(data)
      rescue Yajl::ParseError => error
        raise GnipApi::Errors::JsonParser::ParseError.new("Yajl failed to parse: #{error.class} -- #{error.message}")
      end
    end

    def encode data
      return encoder.encode(data)
    end
    
    private
    def parser
      Yajl::Parser.new
    end

    def encoder
      Yajl::Encoder.new
    end
  end
end
