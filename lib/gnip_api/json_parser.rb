module GnipApi
  class JsonParser
    def self.parse data
      return JSON.parse(data)
    end

    def self.encode data
      return JSON.generate(data)
    end
  end
end
