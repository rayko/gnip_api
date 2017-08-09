require 'spec_helper'

def consistent_values
  @consistent_values ||= JSON.parse(read_fixture('rule_value_examples.json'))['consistent']
end

def inconsistent_values
  @inconsistent_values ||= JSON.parse(read_fixture('rule_value_examples.json'))['inconsistent']
end

describe GnipApi::PowerTrack::Rule do
  subject(:rule_class){ GnipApi::PowerTrack::Rule }
  before do
    configure_gem
  end
  
  it 'creates a rule' do
    expect(Proc.new{rule_class.new}).not_to raise_error
  end

  describe 'rule' do
    let(:value){ 'something' }
    let(:tag){ 'tag' }
    let(:rule) {rule_class.new(:value => value, :tag => tag) }

    it('has a value'){ expect(rule.value).to eq(value) }
    it('has a tag'){ expect(rule.tag).to eq(tag) }
  end

  describe '#attributes' do
    context 'with tag' do
      let(:rule){ rule_class.new(:value => 'r1', :tag => 't1') }
      let(:expected_attributes){ {:value => 'r1', :tag => 't1'} }
      
      it('returns expected attributes'){ expect(rule.attributes).to eq(expected_attributes) }
    end

    context 'without tag' do
      let(:rule){ rule_class.new(:value => 'r1') }
      let(:expected_attributes){ {:value => 'r1'} }
      
      it('returns expected attributes'){ expect(rule.attributes).to eq(expected_attributes) }
    end
  end

  describe '#to_json' do
    let(:rule) { rule_class.new(:value => 'value', :tag => 'tag') }
    let(:json) { {:value => 'value', :tag => 'tag'}.to_json }
    
    it('converts to json'){ expect(rule.to_json).to eq(json) }
  end

  describe '#consistent?' do
    let(:rule) { rule_class.new }
    
    context 'without raising exception' do
      consistent_values.each do |value|
        it "returns true for consistent value #{value}" do
          rule.value = value
          expect(rule.consistent?).to eq(true)
        end
      end

      inconsistent_values.each do |value|
        it "returns false for inconsistent value #{value}" do
          rule.value = value
          expect(rule.consistent?).to eq(false)
        end
      end
    end

    context 'when raising exception' do
      consistent_values.each do |value|
        it "returns nil for consistent #{value}" do
          rule.value = value
          expect(rule.consistent?(true)).to eq(nil)
        end
      end

      inconsistent_values.each do |value|
        it "raises ArgumentError for inconsistent value #{value}" do
          rule.value = value
          expect(Proc.new{rule.consistent?(true)}).to raise_error(ArgumentError)
        end
      end
    end

  end
end
