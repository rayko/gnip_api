module GnipApi
  module Apis
    module PowerTrack
      class Rule
        attr_accessor :value, :tag

        def initialize params={}
          @value = params[:value]
          @tag = params[:tag]
        end

        def to_json
          @value.to_json
        end
      end
    end
  end
end
