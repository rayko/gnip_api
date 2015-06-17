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

  it 'raises error if no adapter is selected' do
    GnipApi.configure do |c|
      c.user = 'somebody'
      c.password = 'something'
      c.account = 'lol'
      c.adapter_class = nil
    end
    
    expect(Proc.new{GnipApi::Adapter.new}).to raise_error(GnipApi::Errors::MissingAdapter)
  end

  it 'does not raise error when credentials and adapter are present' do
    configure_gem
    expect(Proc.new{GnipApi::Adapter.new}).not_to raise_error
  end

  it 'uses adapter selected' do
    configure_gem
    GnipApi.configuration.adapter_class = TestAdapter
    expect(GnipApi::Adapter.new.adapter.class).to eq(TestAdapter)
  end

  describe '#get' do
    before do
      configure_gem
      @adapter = GnipApi::Adapter.new
      @request = GnipApi::Request.new_get(@uri)
    end

    it 'returns a body' do
      result = @adapter.get @request
      expect(result).to eq('get_result') # Defined at spec/lib/test_adapter.rb
    end
  end

  describe '#post' do
    before do
      configure_gem
      @adapter = GnipApi::Adapter.new
      @request = GnipApi::Request.new_post(@uri, 'some_payload')
    end

    it 'returns a body' do
      result = @adapter.post @request
      expect(result).to eq('post_result') # Defined at spec/lib/test_adapter.rb
    end
  end

  describe '#delete' do
    before do
      configure_gem
      @adapter = GnipApi::Adapter.new
      @request = GnipApi::Request.new_delete(@uri, 'some_payload')
    end

    it 'returns a body' do
      result = @adapter.delete @request
      expect(result).to eq('delete_result') # Defined at spec/lib/test_adapter.rb
    end
  end

end
