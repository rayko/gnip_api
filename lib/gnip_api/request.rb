module GnipApi
  class Request
    attr_reader :uri, :payload, :headers, :request_method

    class << self
      def new_get uri, headers=nil
        new(:uri => uri, :headers => headers, :request_method => GnipApi::Adapter::GET)
      end
      
      def new_post uri, payload, headers=nil
        new(:uri => uri, :headers => headers, :payload => payload, :request_method => GnipApi::Adapter::POST)
      end
      
      def new_delete uri, payload, headers=nil
        new(:uri => uri, :headers => headers, :payload => payload, :request_method => GnipApi::Adapter::POST)
      end
    end

    def initialize params={}
      @uri = params[:uri]
      @payload = params[:payload]
      @headers = params[:headers]
      @request_method = params[:request_method]
      @adapter = GnipApi::Adapter.new
    end

    def execute!
      log!
      case request_method
      when GnipApi::Adapter::GET
        response = @adapter.get(self)
      when GnipApi::Adapter::POST
        response = @adapter.post(self)
      when GnipApi::Adapter::DELETE
        response = @adapter.delete(self)
      else
        raise 'RequestNotAllowed'
      end
      response.check_for_errors!
      return response.body unless response.body.empty?
      return true
    end

    def log!
      GnipApi.logger.info "Starting #{request_method} request to #{uri}"
      GnipApi.logger.debug "Headers -> #{headers.inspect}"
      GnipApi.logger.debug "Payload -> #{payload.inspect}"
    end

  end
end
