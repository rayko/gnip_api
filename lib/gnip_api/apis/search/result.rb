module GnipApi
  module Apis
    module Search
      class Result
        attr_reader :activities, :response
        
        def initialize response
          @response = response
        end
        
        def activities
          @activities ||= response['results'].map { |activity| Activity.new(activity) }
        end
      end
    end
  end
end
