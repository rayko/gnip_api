module GnipApi
  module PowerTrack
    # Represents a PowerTrack rule with its necesary attribures.
    class Rule
      attr_accessor :value, :tag, :id

      def initialize params={}
        @value = params[:value] || params['value']
        @tag = params[:tag] || params['tag']
        @id = params[:id] || params['id']
      end

      def to_json
        attributes.to_json
      end

      def attributes
        attrs = {}
        attrs[:value] = @value if @value
        attrs[:tag] = @tag if @tag
        attrs[:id] = @id if @id
        attrs
      end

      def uid
        rule = @value
        rule += "tag:#{@tag}" if @tag
        Digest::SHA2.hexdigest(rule)
      end

      # Simply checks balance of quotes and parenthesis within the value. Quoted text
      # is sort of escaped as long as it's consistently quoted.
      def consistent? raise_error=false
        characters = value.chars
        parenthesis = 0
        in_double_quotes = false
        in_single_quotes = false
        char = characters.shift
        while char
          parenthesis += 1 if (char == '(')
          parenthesis -= 1 if (char == ')')

          if char == '"'
            in_double_quotes = true
            char = characters.shift
            while char != '"'
              char = characters.shift
              break if char.nil?
            end
            in_double_quotes = false if char == '"'
          end

          if char == "'"
            in_single_quotes = true
            char = characters.shift
            while char != "'"
              char = characters.shift
              break if char.nil?
            end
            in_single_quotes = false if char == "'"
          end

          char = characters.shift
        end

        if raise_error
          raise ArgumentError.new("Imbalanced parenthesis") if parenthesis != 0
          raise ArgumentError.new("Imbalanced single quotes") if in_single_quotes != false
          raise ArgumentError.new("Imbalanced double quotes") if in_double_quotes != false
          return nil
        end
        return parenthesis == 0 && in_single_quotes == false && in_double_quotes == false
      end

    end
  end
end
