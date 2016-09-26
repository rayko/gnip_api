module GnipApi
  class JsonParser
    def self.parse data
      begin
        return parser.parse(data)
      rescue Yajl::ParseError => error
        raise GnipApi::Errors::JsonParser::ParseError.new("Yajl failed to parse: #{error.class} -- #{error.message}")
      end
    end

    def self.encode data
      return encoder.encode(data)
    end
    
    private
    def self.parser
      Yajl::Parser.new
    end

    def self.encoder
      Yajl::Encoder.new
    end
  end
end
