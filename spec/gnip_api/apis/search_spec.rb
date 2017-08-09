require 'spec_helper'

describe GnipApi::Apis::Search do
  describe '.new' do
    it 'creates search instance' do
      object = GnipApi::Apis::Search.new
      expect(object).not_to eq(nil)
      expect(object.class).to eq(GnipApi::Apis::Search)
    end
  end

  describe '#counts' do
    before do
      @raw_response = File.read(fixture_path.join('search_api/search_counts_response.json'))
      @api = GnipApi::Apis::Search.new
      allow(@api.adapter).to receive(:post).and_return(@raw_response)
    end

    it 'raises error if missing params' do
      expect(Proc.new{@api.counts}).to raise_error(GnipApi::Errors::Search::MissingParameters)
    end

    it 'performs request and parses response' do
      rule = GnipApi::PowerTrack::Rule.new :value => 'lolcat OR madcat'
      result = @api.counts :rule => rule
      expect(result).not_to eq(nil)
    end

    describe 'result set' do
      before do
        rule = GnipApi::PowerTrack::Rule.new :value => 'lolcat OR madcat'
        @result = @api.counts :rule => rule
      end

      it 'should be hash' do
        expect(@result.class).to eq(Hash)
      end

      it 'contains specific keys' do
        expect(@result.keys).to eq([:results, :total_count, :next, :request_parameters])
      end

      it 'has parsed items on results key' do
        expect(@result[:results].first.class).to eq(Hash)
      end

      it 'has time period on items' do
        expect(@result[:results].first.keys).to include(:time_period)
      end

      it 'has time period as Time object' do
        expect(@result[:results].first[:time_period].class).to eq(Time)
      end

      it 'has count' do
        expect(@result[:results].first.keys).to include(:count)
      end

      it 'has number as count' do
        expect(@result[:results].first[:count].class).to eq(Fixnum)
      end
    end
  end

  describe '#activities' do
    before do
      @raw_response = File.read(fixture_path.join('search_api/search_activities_response.json'))
      @api = GnipApi::Apis::Search.new
      allow(@api.adapter).to receive(:post).and_return(@raw_response)
    end

    it 'raises error if missing params' do
      expect(Proc.new{@api.activities}).to raise_error(GnipApi::Errors::Search::MissingParameters)
    end

    it 'performs request and parses response' do
      rule = GnipApi::PowerTrack::Rule.new :value => 'lolcat OR madcat'
      result = @api.activities :rule => rule
      expect(result).not_to eq(nil)
    end

    describe 'result set' do
      before do
        rule = GnipApi::PowerTrack::Rule.new :value => 'lolcat OR madcat'
        @result = @api.activities :rule => rule
      end

      it 'should be hash' do
        expect(@result.class).to eq(Hash)
      end

      it 'contains specific keys' do
        expect(@result.keys).to eq([:results, :next, :request_parameters])
      end

      it 'has parsed items on results key' do
        expect(@result[:results].first.class).to eq(Gnip::Activity)
      end
    end
  end
end
