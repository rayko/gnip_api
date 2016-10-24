require 'spec_helper'

describe GnipApi::Configuration do
  describe 'OUTPUT_FORMATS' do
    it 'includes :json' do
      expect(GnipApi::Configuration::OUTPUT_FORMATS.include?(:json)).to eq(true)
    end

    it 'includes :activity' do
      expect(GnipApi::Configuration::OUTPUT_FORMATS.include?(:activity)).to eq(true)
    end

    it 'includes :parsed_json' do
      expect(GnipApi::Configuration::OUTPUT_FORMATS.include?(:parsed_json)).to eq(true)
    end
  end

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
