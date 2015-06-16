require 'spec_helper'

describe GnipApi::Apis::PowerTrack::Rules do
  before do
    @api = GnipApi::Apis::PowerTrack::Rules.new(:source => 'source', :label => 'label')
    @rules = [GnipApi::Apis::PowerTrack::Rule.new(:value => 'r1', :tag => 't1'),
              GnipApi::Apis::PowerTrack::Rule.new(:value => 'r2')]
    @json = {:rules => [{:value => 'r1', :tag => 't1'}, {:value => 'r2'}]}.to_json
  end

  describe '#parse_rules' do
    it 'parses json rules to GnipApi::Apis::PowerTrack::Rule objects' do
      parsed = @api.parse_rules(@json)
      expect(parsed.first.class).to eq(GnipApi::Apis::PowerTrack::Rule)
    end
  end

  describe '#construct_rules' do
    it 'constructs valid rules' do
      expect(@api.construct_rules(@rules)).to eq(@json)
    end
  end

  describe '#delete' do
    it 'raises error if no rules passed' do
      expect(Proc.new{@api.delete([])}).to raise_error(GnipApi::Errors::PowerTrack::MissingRules)
    end
  end

  describe '#create' do
    it 'raises error if no rules passed' do
      expect(Proc.new{@api.create([])}).to raise_error(GnipApi::Errors::PowerTrack::MissingRules)
    end
  end

  describe '#list' do
    before do
      expect(@api.adapter).to receive(:get).and_return(@json)
    end

    it 'returns an array' do
      result = @api.list
      expect(result.kind_of?(Array)).to eq(true)
    end
    
    it 'gets 2 rules' do
      result = @api.list
      expect(result.size).to eq(2)
    end

    it 'returns GnipApi::Apis::PowerTrack::Rule objects' do
      result = @api.list
      expect(result.map(&:class).uniq).to eq([GnipApi::Apis::PowerTrack::Rule])
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
