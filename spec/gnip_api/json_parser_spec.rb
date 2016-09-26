require 'spec_helper'

describe GnipApi::JsonParser do
  describe ".parse" do
    it 'parses a JSON object' do
      output = GnipApi::JsonParser.parse('{"key":"value","key2":"value2"}')
      expect(output).to eq({'key' => 'value', 'key2' => 'value2'})
    end
  end

  describe ".encode" do
    it 'generates a JSON object' do
      output = GnipApi::JsonParser.encode({:key => 'value', :key2 => 'value2'})
      expect(output).to eq('{"key":"value","key2":"value2"}')
    end
  end
end
