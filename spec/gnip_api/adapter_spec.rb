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
end
