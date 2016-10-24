require 'spec_helper'

describe GnipApi::Configuration do
  describe '#new' do
    it 'has the default values' do
      config = GnipApi::Configuration.new

      expect(config.user).to eq(nil)
      expect(config.password).to eq(nil)
      expect(config.account).to eq(nil)
      expect(config.adapter_class).to eq(GnipApi::Adapters::HTTPartyAdapter)
      expect(config.logger).not_to eq(nil)
      expect(config.source).to eq(nil)
      expect(config.label).to eq(nil)
      expect(config.debug).to eq(false)
    end
  end

end
