module Gnip
  class SystemMessage < Gnip::Message
    attr_reader :message, :sent, :message_type

    def initialize params
      @message_type = params.keys.first
      @message = params['message']
      @sent = params['sent']
    end

    def original_attributes
      {
        @message_type => @message,
        :sent => @sent
      }
    end

    def log_method
      @message_type.to_sym
    end

    def message
      @message.strip
    end
    
    def to_json
      generate_json(original_attributes)
    end
  end
end
