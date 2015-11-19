require 'spec_helper'

describe Gnip::GnipData do
  context 'with long rules' do
    before do
      @activity = File.read(fixture_path.join('activities', 'real_activity_long_rules.json'))
      @activity = JSON.parse(@activity)
      @gnip = @activity['gnip']
    end

    it 'accepts gnip data' do
      expect(Proc.new{Gnip::GnipData.new(@gnip)}).not_to raise_error
    end

    describe 'parsed GnipData' do
      before do
        @gnip_data = Gnip::GnipData.new(@gnip)
      end

      it 'has matching rules' do
        expect(@gnip_data.matching_rules).not_to eq(nil)
      end

      it 'has urls' do
        expect(@gnip_data.urls).not_to eq(nil)
      end

      it 'has language' do
        expect(@gnip_data.language).not_to eq(nil)
      end

      describe 'matching rules' do
        before do
          @matching_rules = @gnip_data.matching_rules
        end

        it 'has no rule value' do
          expect(@matching_rules.first.value).to eq(nil)
        end

        it 'has tag' do
          expect(@matching_rules.first.tag).not_to eq(nil)
        end
      end
    end
  end
  
  context 'with short rules' do
    before do
      @activity = File.read(fixture_path.join('activities', 'real_activity.json'))
      @activity = JSON.parse(@activity)
      @gnip = @activity['gnip']
    end

    it 'accepts gnip data' do
      expect(Proc.new{Gnip::GnipData.new(@gnip)}).not_to raise_error
    end

    describe 'parsed GnipData' do
      before do
        @gnip_data = Gnip::GnipData.new(@gnip)
      end

      it 'has matching rules' do
        expect(@gnip_data.matching_rules).not_to eq(nil)
      end

      it 'has urls' do
        expect(@gnip_data.urls).not_to eq(nil)
      end

      it 'has language' do
        expect(@gnip_data.language).not_to eq(nil)
      end

      describe 'matching rules' do
        before do
          @matching_rules = @gnip_data.matching_rules
        end

        it 'has rule value' do
          expect(@matching_rules.first.value).not_to eq(nil)
        end

        it 'has tag' do
          expect(@matching_rules.first.tag).not_to eq(nil)
        end
      end
    end
  end
  
end
