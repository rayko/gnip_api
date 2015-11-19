require 'spec_helper'

describe Gnip::Message do
  context 'twitter' do
    before do
      @retweet_json = File.read(fixture_path.join('twitter_messages', 'retweet.json'))
      @tweet_json = File.read(fixture_path.join('twitter_messages', 'tweet.json'))
      @retweet_json_long_rules = File.read(fixture_path.join('twitter_messages', 'retweet_long_rules.json'))
      @tweet_json_long_rules = File.read(fixture_path.join('twitter_messages', 'tweet_long_rules.json'))
      @retweet = JSON.parse @retweet_json
      @tweet = JSON.parse @tweet_json
      @tweet_long_rules = JSON.parse @tweet_json_long_rules
      @retweet_long_rules = JSON.parse @retweet_json_long_rules
    end
    
    it 'accepts retweet data' do
      expect(Proc.new{Gnip::Activity.new(@retweet)}).not_to raise_error
    end

    it 'accepts tweet data' do
      expect(Proc.new{Gnip::Activity.new(@tweet)}).not_to raise_error      
    end

    it 'accepts tweet data with long rules' do
      expect(Proc.new{Gnip::Activity.new(@tweet_long_rules)}).not_to raise_error
    end

    it 'accepts retweet data with long rules' do
      expect(Proc.new{Gnip::Activity.new(@retweet_long_rules)}).not_to raise_error
    end

    context 'retweet' do
      before do
        @activity = Gnip::Activity.new @retweet
      end

      it 'has id' do
        expect(@activity.id).to eq(@retweet['id'])
      end

      it 'parses network id' do
        expect(@activity.tweet_id).to eq(@retweet['id'].split(':').last)
      end

      it 'has activity object type' do
        expect(@activity.object_type).to eq('activity')
      end

      it 'has share as verb' do
        expect(@activity.verb).to eq('share')
      end
      
      it 'has actor' do
        expect(@activity.actor).not_to eq(nil)
      end
      
      it 'has Gnip::Actor object actor' do
        expect(@activity.actor.class).to eq(Gnip::Actor)
      end

      it 'has posted_time' do
        expect(@activity.posted_time).not_to eq(nil)
      end

      it 'has parsed posted_time' do
        expect(@activity.posted_time.kind_of?(DateTime)).to eq(true)
      end

      it 'has generator data' do
        expect(@activity.generator).not_to eq(nil)
      end

      it 'has provider data' do
        expect(@activity.provider).not_to eq(nil)
      end

      it 'has link' do
        expect(@activity.link).not_to eq(nil)
      end

      it 'has URI as link' do
        expect(@activity.link.kind_of?(URI)).to eq(true)
      end

      it 'has body' do
        expect(@activity.body).not_to eq(nil)
      end

      it 'has object' do
        expect(@activity.object).not_to eq(nil)
      end

      it 'has another activity object as object' do
        expect(@activity.object.class).to eq(Gnip::Activity)
      end

      it 'has favorites_count' do
        expect(@activity.favorites_count).not_to eq(nil)
      end

      it 'has twitter_entities' do
        expect(@activity.twitter_entities).not_to eq(nil)
      end

      it 'has tiwtter_filter_level' do
        expect(@activity.twitter_filter_level).not_to eq(nil)
      end

      it 'has twitter_lang' do
        expect(@activity.twitter_lang).not_to eq(nil)
      end

      it 'has retweet_count' do
        expect(@activity.retweet_count).not_to eq(nil)
      end

      it 'has gnip data' do
        expect(@activity.gnip).not_to eq(nil)
      end
      
    end
  end
end
