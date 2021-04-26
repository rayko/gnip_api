module Gnip
  module Parser

    def new_from_json json_data
      parser = GnipApi::JsonParser.new
      data = parser.parse(json_data)
      new(data)
    end

  end
end
