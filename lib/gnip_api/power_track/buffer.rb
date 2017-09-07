module GnipApi
  module PowerTrack
    # Collects raw data from the stream received in chunks and splits
    # it using the \r\n character to return complete items in JSON
    # format.
    class Buffer
      attr_reader :terminator, :data, :logger
      
      def initialize options={}
        @terminator = options.delete(:terminator) || "\r\n"
        @data = ""
        @logger = GnipApi.logger
        @check_span = 30
        @last_check = Time.now
      end
      
      # Returns the current size of the buffer.
      def size
        @data.size
      end
      
      # Inserts a +chunk+ into the buffer.
      def insert! chunk
        check
        @data << chunk
      end

      # Splits the data and gets completed items from the buffer
      # to remove them from the buffer and return them as an Array
      # of items.
      #
      # +@data+ is a simple String object that gets stuff added
      # and using #read! gets stuff removed. At any moment +@data+ can
      # contain:
      # - a fragment of an item
      # - a complete item and a fragment of another
      # - one or more complete items
      # - a complete item followed by various terminator chars
      # In all cases #read! will return complete items only, removing
      # these from +@data+ as it reads it. The way it does this is
      # by finding the last terminator from right to left. String#rindex
      # method will return the index (starting at 0) of the first char
      # of the terminator. To properly read the data, a +1 is added to this
      # index. Then another +1 is added to make it a count for #consume!
      # to read. Note that #consume! eats up an amount of characters from
      # left to right. The cut piece from the buffer is then splitted by
      # the terminator to return the completed items. In the cut piece
      # a terminator at the end will always be present, but the Array#split
      # method already ignores that final one.
      #
      # If there's a single incomplete fragment in +@data+, the index lookup
      # will return +nil+ and an empty list will be returned, signaling
      # nothing to read in the buffer and doing nothing to it until more
      # chunks are inserted.
      #
      # In the case many terminator chars end up in the buffer, after split
      # these will render as empty strings and removed from the list of
      # items to return.
      def read!
        objects = []
        last_terminator_index = @data.rindex(terminator)
        if last_terminator_index
          last_terminator_index += 1 # include the following \n
          objects = consume!(last_terminator_index + 1) # extract upto las terminator positin, +1 because it's an index
          objects = objects.split(terminator).delete_if{|item| item.nil? || item.size == 0}
        end
        return objects
      end

      # Reads +char_count+ characters from +@data+ removing them, and
      # returns the extracted characters.
      def consume! char_count
        @data.slice!(0, char_count)
      end

      private
      # Logs info about the buffer stats each +@check_span+ seconds.
      def check
        return unless logger.level <= Logger::INFO
        if Time.now.to_i > @last_check.to_i + @check_span
          @last_check = Time.now
          logger.info "Current buffer size is #{size} bytes"
        end
      end

    end
  end
end
