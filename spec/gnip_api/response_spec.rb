require 'spec_helper'

describe GnipApi::Response do
  before { @uri = URI('http://somewhere.com') }
  it 'creates a response' do
    request = GnipApi::Request.new_get @uri
    expect(Proc.new{GnipApi::Response.new(request, 200, 'body', {:header => 'a header'})}).not_to raise_error
  end

  describe '#error_message' do
    context 'when 429' do
      let(:request) { GnipApi::Response.new(GnipApi::Request.new, 429, "{\"error\":{\"message\":\"Exceeded rate limit\",\"sent\":\"2018-02-06T16:35:03+00:00\",\"transactionId\":\"000ea40b00c3da1e\"}}", {}) }
      it 'parses the body and returns message' do
        expect(request.error_message).to eq("Exceeded rate limit - TID: 000ea40b00c3da1e")
      end
    end

    context 'when 503' do
      let(:request) { GnipApi::Response.new(GnipApi::Request.new, 503, "{\"error\":{\"message\":\"Gnip software error\",\"sent\":\"2018-02-06T16:35:03+00:00\",\"transactionId\":\"000ea40b00c3da1e\"}}", {}) }
      it 'parses the body and returns message' do
        expect(request.error_message).to eq("Gnip software error - TID: 000ea40b00c3da1e")
      end
    end
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

  describe '#check_for_errors!' do
    let(:request) { GnipApi::Request.new_get(@uri) }
    context 'when is ok' do
      let(:response) { GnipApi::Response.new(request, 200, 'good body', {}) }
      it('does not throw exception') { expect(Proc.new{response.check_for_errors!}).not_to raise_error }
    end

    context 'when rate limited' do
      let(:error_message){ {"error"=>{"message"=>"Exceeded rate limit", "sent"=>"2017-06-05T16:20:43+00:00", "transactionId"=>"00629e29000a91c1"}}.to_json }
      let(:response) { GnipApi::Response.new(request, 429, error_message, {}) }
      it('raises RateLimitError') { expect(Proc.new{response.check_for_errors!}).to raise_error(GnipApi::Errors::Adapter::RateLimitError) }
    end

    context 'when software error' do
      let(:error_message){ {"error"=>{"message"=>"some server error", "sent"=>"2017-06-05T16:20:43+00:00", "transactionId"=>"00629e29000a91c1"}}.to_json }
      let(:response) { GnipApi::Response.new(request, 503, error_message, {}) }
      it('raises GnipSoftwareError') { expect(Proc.new{response.check_for_errors!}).to raise_error(GnipApi::Errors::Adapter::GnipSoftwareError) }
    end

    context 'when other error' do
      let(:error_message){ {"error"=>{"message"=>"Exceeded rate limit", "sent"=>"2017-06-05T16:20:43+00:00", "transactionId"=>"00629e29000a91c1"}}.to_json }
      let(:response) { GnipApi::Response.new(request, 400, error_message, {}) }
      it('raises generic error') { expect(Proc.new{response.check_for_errors!}).to raise_error(GnipApi::Errors::Adapter::RequestError) }
    end
  end

end
