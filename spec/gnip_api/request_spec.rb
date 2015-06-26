require 'spec_helper'

describe GnipApi::Request do
  it 'generates a request' do
    expect(Proc.new{GnipApi::Request.new}).not_to raise_error
  end

  describe 'request data' do
    before do
      @uri = 'http://localt.com'
      @payload = 'some_payload'
      @headers = {:header => 'a_header'}
      @method = 'POST'
      @request = GnipApi::Request.new(:uri => @uri, :request_method => @method, :payload => @payload, :headers => @headers)
    end
    
    it 'sets method' do
      expect(@request.request_method).to eq(@method)
    end

    it 'sets uri' do
      expect(@request.uri).to eq(@uri)
    end
    
    it 'sets payload' do
      expect(@request.payload).to eq(@payload)
    end
    
    it 'sets headers' do
      expect(@request.headers).to eq(@headers)
    end
  end
end
