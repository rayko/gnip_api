module Gnip
  class Message
    SYSTEM_MESSAGE_TYPES = ['error', 'warn', 'info']
    TWITTER_COMPLIANCE_MESSAGES = ['delete', 'user_delete', 'user_undelete', 'scrub_geo', 
                                   'user_protect', 'user_unprotect', 'user_suspend', 'user_unsuspend',
                                   'user_withheld', 'status_withheld']

    def self.build params
      return build_system_message(params) if (SYSTEM_MESSAGE_TYPES & params.keys).any?
      return build_twitter_compliance_message(params) if TWITTER_COMPLIANCE_MESSAGES.include? params['verb']
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
      GnipApi::JsonParser.new.encode(data)
    end

    private
    def self.build_system_message params
      Gnip::SystemMessage.new params
    end

    def self.build_twitter_compliance_message params
      Gnip::TwitterComplianceMessage.new params
    end

    def self.build_activity params
      Gnip::Activity.new params
    end
  end
end
