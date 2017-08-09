require 'spec_helper'

describe GnipApi::PowerTrack::Stream do
  before do
    configure_gem
    @stream = GnipApi::PowerTrack::Stream.new
  end

  describe '#initialize' do
    it 'throws GnipApi::Errors::Configuration::InvalidOutputFormat when not included' do
      GnipApi.configuration.stream_output_format = :invalid
      expect(Proc.new{GnipApi::PowerTrack::Stream.new}).to raise_error(GnipApi::Errors::Configuration::InvalidOutputFormat)
    end
  end

  describe '#process_entries' do
    before do
      @json = File.read('spec/fixtures/activities/real_activity.json')
    end
    
    context 'when output format is :activity' do
      it 'bulds a Message object from the json' do
        message = @stream.process_entries([@json])
        expect(message.first.class).to eq(Gnip::Activity)
      end

      it 'returns empty array if could not parse json' do
        message = @stream.process_entries(['lol'])
        expect(message).to eq([])
      end
    end

    context 'when output format is :parsed_json' do
      before do
        GnipApi.configuration.stream_output_format = :parsed_json
        @stream = GnipApi::PowerTrack::Stream.new
      end

      it 'parses json' do
        message = @stream.process_entries([@json])
        expect(message.first.class).to eq(Hash)
      end

      it 'returns empty array if could not parse json' do
        message = @stream.process_entries(['lol'])
        expect(message).to eq([])
      end
    end

    context 'when output format is :json' do
      before do 
        GnipApi.configuration.stream_output_format = :json
        @stream = GnipApi::PowerTrack::Stream.new
      end

      it 'returns raw json' do
        message = @stream.process_entries([@json])
        expect(message.first.class).to eq(String)
      end

      it 'returns whatever stream returns' do
        message = @stream.process_entries(['lol'])
        expect(message).to eq(['lol'])
      end
    end
  end

  describe '#parse_json' do
    before do
      @json = File.read('spec/fixtures/activities/real_activity.json')
    end

    it 'does not throw error with activity json' do
      expect(Proc.new{@stream.parse_json(@json)}).not_to raise_error
    end

    it 'parses json' do
      parsed = @stream.parse_json @json
      expect(parsed.class).to eq(Hash)
    end

    it 'returns nil if empty json is passed' do
      parsed = @stream.parse_json('')
      expect(parsed).to eq(nil)
    end
    
    it 'returns nil if invalid json is passed' do
      parsed = @stream.parse_json('12,4.,x_VZxuv8{ak{f}}}}} {{ (d(s)aa(((aaaaa)aaa)')
      expect(parsed).to eq(nil)
    end
    
  end
end
