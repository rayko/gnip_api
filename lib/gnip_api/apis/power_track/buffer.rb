module GnipApi
  module Apis
    module PowerTrack
      class Buffer
        attr_reader :terminator, :data

        def initialize options={}
          @terminator = options.delete(:terminator) || "\r\n"
          @data = ""
        end
        
        def insert! chunk
          @data << chunk
        end

        def read!
          objects = @data.split(terminator)[0..-2]
          unless objects.empty?
            size = objects.map(&:size).reduce(:+) + objects.size * terminator.size
            consume!(size)
          end
          return objects
        end

        def consume! chars
          @data[0..chars-1] = ''
        end
      end
    end
  end
end
