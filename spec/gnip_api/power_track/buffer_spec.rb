require 'spec_helper'

describe GnipApi::PowerTrack::Buffer do
  before do
    @buffer = GnipApi::PowerTrack::Buffer.new(:terminator => '--')
  end
  
  it 'has "--" as terminator char' do
    expect(@buffer.terminator).to eq('--')
  end

  it 'stores string data' do
    expect(@buffer.data.kind_of?(String)).to eq(true)
  end

  describe '#insert!' do
    it 'apends data at the end' do
      @buffer.insert! "asd"
      expect(@buffer.data[-1]).to eq('d')
      @buffer.insert! 'lol'
      expect(@buffer.data[-1]).to eq('l')
    end
  end

  describe '#read!' do
    context 'with partial data' do
      before do
        @buffer.insert! 'asd--qwe--x'
      end
      
      it 'gets complete objects' do
        objects = @buffer.read!
        expect(objects.empty?).to eq(false)
      end

      it 'consumes data from buffer' do
        @buffer.read!
        expect(@buffer.data).to eq('x')
      end
    end

    context 'with complete data' do
      before do
        @buffer.insert! 'asd--qwe--zxc'
      end

      it 'gets complete objects except for last one' do
        objects = @buffer.read!
        expect(objects.size).to eq(2)
      end

      it 'removes the data read' do
        @buffer.read!
        expect(@buffer.data.include?('asd')).to eq(false)
      end
    end
  end
end
