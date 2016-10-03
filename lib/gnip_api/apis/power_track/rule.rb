module GnipApi
  module Apis
    module PowerTrack
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
      end
    end
  end
end
