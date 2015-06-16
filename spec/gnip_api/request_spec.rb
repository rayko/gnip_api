require 'spec_helper'

describe GnipApi::Request do
  it 'generates a only with a URI object' do
    expect(Proc.new{GnipApi::Request.new(URI('http://lolcat.com'))}).not_to raise_error
  end

  describe 'request data' do
    before do
      @uri = 'http://localt.com'
      @payload = 'some_payload'
      @headers = {:header => 'a_header'}
      @request = GnipApi::Request.new(@uri, @payload, @headers)
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
