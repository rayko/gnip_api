require 'spec_helper'

describe GnipApi::PowerTrack::Rule do
  before do
    configure_gem
  end
  
  it 'creates a rule' do
    expect(Proc.new{GnipApi::PowerTrack::Rule.new}).not_to raise_error
  end

  describe 'rule' do
    before do
      @value = 'something'
      @tag = 'tag'
      @rule = GnipApi::PowerTrack::Rule.new :value => @value, :tag => @tag
    end

    it 'has a value' do
      expect(@rule.value).to eq(@value)
    end
    
    it 'has a tag' do
      expect(@rule.tag).to eq(@tag)
    end
  end

  describe '#attributes' do
    context 'with tag' do
      before do
        @rule = GnipApi::PowerTrack::Rule.new(:value => 'r1', :tag => 't1')
        @attributes = {:value => 'r1', :tag => 't1'}
      end
      
      it 'returns hash with attributes' do
        expect(@rule.attributes).to eq(@attributes)
      end
    end

    context 'without tag' do
      before do
        @rule = GnipApi::PowerTrack::Rule.new(:value => 'r1')
        @attributes = {:value => 'r1'}
      end
      
      it 'returns hash with attributes' do
        expect(@rule.attributes).to eq(@attributes)
      end
    end
  end

  describe '#to_json' do
    before do
      @rule = GnipApi::PowerTrack::Rule.new :value => 'value', :tag => 'tag'
      @json = {:value => 'value', :tag => 'tag'}.to_json
    end
    
    it 'converts to json' do
      expect(@rule.to_json).to eq(@json)
    end
  end
end
