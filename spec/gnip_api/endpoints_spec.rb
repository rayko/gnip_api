require 'spec_helper'

describe GnipApi::Endpoints do
  before do
    configure_gem
    @source = 'somewhere'
    @label = 'stream'
  end
  
  describe '.powertrack_rules' do
    it 'returns URI object' do
      expect(GnipApi::Endpoints.powertrack_rules(@source, @label).kind_of?(URI)).to eq(true)
    end

    describe 'URI returned' do
      before do
        @uri = GnipApi::Endpoints.powertrack_rules(@source, @label)
      end
      it 'contains source in path' do
        expect(@uri.path.include?(@source)).to eq(true)
      end

      it 'contains label in path' do
        expect(@uri.path.include?(@label)).to eq(true)
      end

      it 'includes account in path' do
        expect(@uri.path.include?(GnipApi.configuration.account)).to eq(true)
      end
    end
  end

  describe '.powertrack_stream' do
    it 'returns URI object' do
      expect(GnipApi::Endpoints.powertrack_stream(@source, @label).kind_of?(URI)).to eq(true)
    end

    describe 'URI returned' do
      before do
        @uri = GnipApi::Endpoints.powertrack_stream(@source, @label)
      end
      it 'contains source in path' do
        expect(@uri.path.include?(@source)).to eq(true)
      end

      it 'contains label in path' do
        expect(@uri.path.include?(@label)).to eq(true)
      end

      it 'includes account in path' do
        expect(@uri.path.include?(GnipApi.configuration.account)).to eq(true)
      end
    end
  end
  
end
