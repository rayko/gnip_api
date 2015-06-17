require 'spec_helper'

describe GnipApi::Response do
  before { @uri = URI('http://somewhere.com') }
  it 'creates a response' do
    request = GnipApi::Request.new_get @uri
    expect(Proc.new{GnipApi::Response.new(request, 200, 'body', {:header => 'a header'})}).not_to raise_error
  end

  describe 'response data' do
    before do
      @status = 100
      @body = 'something'
      @headers = {:header => 'something'}
      @request = GnipApi::Request.new_get @uri
      @response = GnipApi::Response.new(@request, @status, @body, @headers)
    end
    
    it 'has a status' do
      expect(@response.status).to eq(@status)
    end
    
    it 'has a body' do
      expect(@response.body).to eq(@body)
    end
    
    it 'has headers' do
      expect(@response.headers).to eq(@headers)
    end

  end
end
