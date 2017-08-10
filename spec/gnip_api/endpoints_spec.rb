require 'spec_helper'

describe GnipApi::Endpoints do
  before do
    configure_gem
  end
  
  describe '.powertrack_rules' do
    it 'returns URI object' do
      expect(GnipApi::Endpoints.powertrack_rules.kind_of?(URI)).to eq(true)
    end

    describe 'URI returned' do
      before do
        @uri = GnipApi::Endpoints.powertrack_rules
      end

      it 'contains label in path' do
        expect(@uri.path.include?(GnipApi.configuration.label)).to eq(true)
      end

      it 'includes account in path' do
        expect(@uri.path.include?(GnipApi.configuration.account)).to eq(true)
      end
    end
  end

  describe '.powertrack_stream' do
    it 'returns URI object' do
      expect(GnipApi::Endpoints.powertrack_stream.kind_of?(URI)).to eq(true)
    end

    describe 'URI returned' do
      before do
        @uri = GnipApi::Endpoints.powertrack_stream
      end

      it 'contains label in path' do
        expect(@uri.path.include?(GnipApi.configuration.label)).to eq(true)
      end

      it 'includes account in path' do
        expect(@uri.path.include?(GnipApi.configuration.account)).to eq(true)
      end
    end
  end
  
end
