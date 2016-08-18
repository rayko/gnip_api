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
      @api = GnipApi::Apis::Search.new
      allow(@api.adapter).to receive(:post).and_return("{\"results\":[{\"timePeriod\":\"201607200000\",\"count\":87},{\"timePeriod\":\"201607190000\",\"count\":188}],\"totalCount\":5949,\"requestParameters\":{\"bucket\":\"day\",\"fromDate\":\"201607190000\",\"toDate\":\"201608181340\"}}")
    end

    it 'raises error if missing params' do
      expect(Proc.new{@api.counts}).to raise_error(GnipApi::Errors::Search::MissingParameters)
    end

    it 'performs request and parses response' do
      rule = GnipApi::Apis::PowerTrack::Rule.new :value => 'lolcat OR madcat'
      result = @api.counts :rule => rule
      expect(result).not_to eq(nil)
      expect(result.keys).to eq([:results, :total_count, :next, :request_parameters])
    end
  end
end
