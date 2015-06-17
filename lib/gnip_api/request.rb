module GnipApi
  class Request
    attr_reader :uri, :payload, :headers, :method

    class << self
      def new_get uri, headers=nil
        new(:uri => uri, :headers => headers, :method => GnipApi::Adapter::GET, )
      end
      
      def new_post uri, payload, headers=nil
        new(:uri => uri, :headers => headers, :payload => payload, :method => GnipApi::Adapter::POST)
      end
      
      def new_delete uri, payload, headers=nil
        new(:uri => uri, :headers => headers, :payload => payload, :method => GnipApi::Adapter::DELETE)
      end
    end

    def initialize params={}
      @uri = params[:uri]
      @payload = params[:payload]
      @headers = params[:headers]
      @method = params[:method]
    end
  end
end
