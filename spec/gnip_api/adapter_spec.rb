require 'spec_helper'

describe GnipApi::Adapter do
  before do
    @uri = URI('http://somwhere.com')
  end

  it 'raises error if no credentials defined' do
    GnipApi.configure do |c|
      c.user = nil
      c.password = nil
      c.account = nil
    end
    expect(Proc.new{GnipApi::Adapter.new}).to raise_error(GnipApi::Errors::MissingCredentials)
  end

  it 'does not raise error when credentials and adapter are present' do
    configure_gem
    expect(Proc.new{GnipApi::Adapter.new}).not_to raise_error
  end

  describe '#check_response_for_errors' do
    before{ configure_gem }
    let(:adapter) { GnipApi::Adapter.new }
    let(:request) { GnipApi::Request.new_get(@uri) }
    
    context 'when is ok' do
      let(:response) { GnipApi::Response.new(request, 200, 'good body', {}) }
      it('does not throw exception') { expect(Proc.new{adapter.check_response_for_errors(response)}).not_to raise_error }
    end

    context 'when rate limited' do
      let(:error_message){ {"error"=>{"message"=>"Exceeded rate limit", "sent"=>"2017-06-05T16:20:43+00:00", "transactionId"=>"00629e29000a91c1"}}.to_json }
      let(:response) { GnipApi::Response.new(request, 429, error_message, {}) }
      it('raises RateLimitError') { expect(Proc.new{adapter.check_response_for_errors(response)}).to raise_error(GnipApi::Errors::Adapter::RateLimitError) }
    end

    context 'when software error' do
      let(:error_message){ {"error"=>{"message"=>"some server error", "sent"=>"2017-06-05T16:20:43+00:00", "transactionId"=>"00629e29000a91c1"}}.to_json }
      let(:response) { GnipApi::Response.new(request, 503, error_message, {}) }
      it('raises GnipSoftwareError') { expect(Proc.new{adapter.check_response_for_errors(response)}).to raise_error(GnipApi::Errors::Adapter::GnipSoftwareError) }
    end

    context 'when other error' do
      let(:error_message){ {"error"=>{"message"=>"Exceeded rate limit", "sent"=>"2017-06-05T16:20:43+00:00", "transactionId"=>"00629e29000a91c1"}}.to_json }
      let(:response) { GnipApi::Response.new(request, 400, error_message, {}) }
      it('raises generic error') { expect(Proc.new{adapter.check_response_for_errors(response)}).to raise_error(GnipApi::Errors::Adapter::RequestError) }
    end

  end

end
