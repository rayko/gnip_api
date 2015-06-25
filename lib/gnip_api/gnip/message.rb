module Gnip
  class Message
    SYSTEM_MESSAGE_TYPES = ['error', 'warn', 'info']

    def self.build params
      return build_system_message(params) if (SYSTEM_MESSAGE_TYPES & params.keys).any?
      return build_activity(params) if params['objectType'] && params['objectType'] == 'activity'
      raise Gnip::UndefinedMessage
    end

    def system_message?
      @message_type ? true : false
    end

    def error?
      @message_type == 'error'
    end
    
    def warn?
      @message_type == 'warn'
    end
    
    def info?
      @message_type == 'info'
    end

    def activity?
      @object_type == 'activity'
    end
    
    def generate_json data
      JSON.generate(data)
    end

    private
    def self.build_system_message params
      Gnip::SystemMessage.new params
    end

    def self.build_activity params
      Gnip::Activity.new params
    end
  end
end
