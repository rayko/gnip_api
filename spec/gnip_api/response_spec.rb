require 'spec_helper'

describe GnipApi::Response do
  it 'creates a response' do
    expect(Proc.new{GnipApi::Response.new(200, 'body', {:header => 'a header'})}).not_to raise_error
  end

  describe 'response data' do
    before do
      @status = 100
      @body = 'something'
      @headers = {:header => 'something'}
      @response = GnipApi::Response.new(@status, @body, @headers)
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
