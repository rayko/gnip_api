require 'spec_helper'

describe Gnip::Url do
  before do
    # Taken from http://support.gnip.com/enrichments/expanded_urls.html
    @raw_data = '{"url": "https://t.co/b9ZdzRxzFK","expanded_url": "http://www.today.com/parents/joke-s-you-kid-11-family-friendly-april-fools-pranks-t83276","expanded_status": 200,"expanded_url_title": "The joke\'s on you, kid: 11 family-friendly April Fools pranks","expanded_url_description": "If your kids are practical jokers, turn this April Fools\' Day into a family affair."}'
    @data = JSON.parse(@raw_data)
  end

  describe '#initialize' do
    it 'receives raw data' do
      expect(Proc.new{Gnip::Url.new(@data)}).not_to raise_error
    end

    describe 'attributes' do
      before{@url = Gnip::Url.new(@raw_data)}

      it 'has url' do
        expect(@url.url).not_to eq(nil)
      end

      it 'has expanded_url' do
        expect(@url.expanded_url).not_to eq(nil)
      end

      it 'has expanded_url_status' do
        expect(@url.expanded_status).not_to eq(nil)
      end

      it 'has expanded_url_title' do
        expect(@url.expanded_url_title).not_to eq(nil)
      end
      
      it 'has expanded_url_description' do
        expect(@url.expanded_url_description).not_to eq(nil)
      end
    end
  end

  describe '#to_h' do
    before{@url = Gnip::Url.new(@data)}

    it 'includes url' do
      expect(@url.to_h[:url]).to eq(@url.url)
    end

    it 'includes expanded_url' do
      expect(@url.to_h[:expanded_url]).to eq(@url.expanded_url)
    end

    it 'includes expanded_url_status' do
      expect(@url.to_h[:expanded_status]).to eq(@url.expanded_status)
    end

    it 'includes expanded_url_title' do
      expect(@url.to_h[:expanded_url_title]).to eq(@url.expanded_url_title)
    end

    it 'includes expanded_url_description' do
      expect(@url.to_h[:expanded_url_description]).to eq(@url.expanded_url_description)
    end
  end

  describe '#to_json' do
    before{@url = Gnip::Url.new(@data)}

    it 'converts to original json' do
      expect(JSON.parse(@url.to_json)).to eq(@data)
    end
  end
end
