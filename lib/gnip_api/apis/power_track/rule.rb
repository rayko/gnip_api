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
          attributes.to_json
        end

        def attributes
          attrs = {}
          attrs[:value] = @value if @value
          attrs[:tag] = @tag if @tag
          attrs
        end

        def uid
          rule = @value
          rule += "tag:#{@tag}" if @tag
          Digest::SHA2.hexdigest(rule)
        end
        
        def original_attributes
          {
            :value => self.value,
            :tag => self.tag
          }
        end
      end
    end
  end
end
