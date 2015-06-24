module Gnip
  class Message
    def self.build params
      if params['error'] || params['warn'] || params['info']
        SystemMessage.new params
      else
        Gnip::Activity.new params
      end
    end

    def system_message?
      false
    end

    def activity?
      false
    end
  end

  class SystemMessage < Message
    attr_accessor :message, :sent

    def initialize params
      @message = params['message']
      @sent = params['sent']
    end

    def system_message?
      true
    end
  end

end
