require 'spec_helper'

describe GnipApi::PowerTrack::Rules do
  before do
    @api = GnipApi::PowerTrack::Rules.new
    @rules = [GnipApi::PowerTrack::Rule.new(:value => 'r1', :tag => 't1'),
              GnipApi::PowerTrack::Rule.new(:value => 'r2')]
    @json = {:rules => [{:value => 'r1', :tag => 't1'}, {:value => 'r2'}]}.to_json
  end

  describe '#parse_rules' do
    it 'parses json rules to GnipApi::PowerTrack::Rule objects' do
      parsed = @api.parse_rules(@json)
      expect(parsed.first.class).to eq(GnipApi::PowerTrack::Rule)
    end
  end

  describe '#construct_rules' do
    it 'constructs valid rules' do
      expect(@api.construct_rules(@rules)).to eq(@json)
    end
  end

  describe '#delete' do
    it 'raises error if no rules passed' do
      expect(Proc.new{@api.delete([])}).to raise_error(ArgumentError)
    end
  end

  describe '#create' do
    it 'raises error if no rules passed' do
      expect(Proc.new{@api.create([])}).to raise_error(ArgumentError)
    end
  end

  describe '#list' do
    before do
      allow(@api).to receive(:fetch_data).and_return(@json)
    end

    it 'returns an array' do
      result = @api.list
      expect(result.kind_of?(Array)).to eq(true)
    end
    
    it 'gets 2 rules' do
      result = @api.list
      expect(result.size).to eq(2)
    end

    it 'returns GnipApi::PowerTrack::Rule objects' do
      result = @api.list
      expect(result.map(&:class).uniq).to eq([GnipApi::PowerTrack::Rule])
    end

    describe 'rules fetched' do
      before do
        @rules = @api.list
      end
      
      it 'contains expected values' do
        expect(@rules.map(&:value)).to eq(['r1', 'r2'])
      end

      it 'contains expected tags' do
        expect(@rules.map(&:tag)).to eq(['t1', nil])
      end
    end
  end
end
