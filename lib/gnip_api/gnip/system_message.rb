module Gnip
  class SystemMessage < Gnip::Message
    attr_reader :message, :sent, :message_type

    def initialize params
      @raw = params
      @message_type = params.keys.first
      @message = params.to_s
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
      @raw.to_json
    end

    def log!
      GnipApi.logger.warn "System Message Received: #{message_type} -- #{message} at #{sent}"
    end
  end
end
