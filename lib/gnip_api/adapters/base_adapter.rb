# BaseAdapter should be used on any adapter for this gem. In order
# to create your own adapter you must inherit this class to 
# let your adapter use the provided functionality of the gem. In 
# other words, this just defines basic methods to provide the 
# custom adapter with basic data.
#
# To create a custom adapter, create your class, and implement the
# following methods that GnipApi::Adapter will need.
#
# - #get
# - #post
# - #delete
# - #stream_get
#
# All single-request methods (stream_get not included), should
# return a GnipApi::Response object with:
#
# - status: integer value for status code (200, 403, etc)
# - body: raw body, no matter if it's json or xml, the implementation of the api will know this
# - headers: a hash with the response headers
#
# The response object is an effort to standarize the data and let Gnip::Adapter 
# operate without the concern of the data format. The helper method to create
# this response is available in this class, and will be available to your class
# when you write your adapter.
#
# The process of parsing the headers to a hash, setting authorization headers or
# parsing response data to break it down to status, body and headers are responsabilities
# of your custom adapter class.
#
# Gnip::Adapter will pass your adapter a Gnip::Request object that contains:
#
# - uri: URI object with url, schema, etc
# - payload: a parsed text to send in the request's body
# - headers: a hash that may contain additional headers
#
# Your adapter should process this object and translate it into a relevant request for
# your desired connector. Note that payload and headers may be nil if not needed.
#
# Last thing to denote, GnipApi::Adapter will expect an instance of your adapter to use.
# What you do inside your adapter or how you implement a specific adapter is up to you.

module GnipApi
  module Adapters
    class BaseAdapter
      def username
        GnipApi.configuration.user
      end
      
      def password
        GnipApi.configuration.password
      end

      def default_timeout
        GnipApi.configuration.request_timeout
      end
      
      def create_response request, status, body, headers
        GnipApi::Response.new request, status, body, headers
      end
    end
  end
end
