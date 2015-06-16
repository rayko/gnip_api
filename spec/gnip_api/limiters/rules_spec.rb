require 'spec_helper'

describe GnipApi::Limiters::Rules do
  before do
    @limiter = Object.new
    @limiter.extend(GnipApi::Limiters::Rules)
    @limiter.rules_init
    allow(@limiter).to receive(:mutex).and_return(Mutex.new)
  end

  describe '#rules_request_allowed?' do
    before do
      Timecop.freeze(Time.now)
    end
    
    after do
      Timecop.return
    end
    
    it 'allows 5 requests' do
      requests = []
      5.times{requests << @limiter.rules_request_allowed?}
      expect(requests.uniq).to eq([true])
    end

    it 'does not allow more than 5 requests' do
      5.times{@limiter.rules_request_allowed?}
      expect(@limiter.rules_request_allowed?).to eq(false)
    end
  end

  describe '#reset_rules_if_expired' do
    before do
      Timecop.freeze(Time.now)
    end
    
    after do
      Timecop.return
    end
    
    it 'does not reset if not expired' do
      current_time = @limiter.rules_last_reset
      current_count = @limiter.rules_requests
      @limiter.reset_rules_if_expired!
      expect(@limiter.rules_last_reset).to eq(current_time)
      expect(@limiter.rules_requests).to eq(current_count)
    end

    it 'resets if expired' do 
      @limiter.add_rules_request!
      current_time = @limiter.rules_last_reset
      current_count = @limiter.rules_requests
      Timecop.travel(Time.at(Time.now.to_i + 1))
      @limiter.reset_rules_if_expired!
      expect(@limiter.rules_last_reset).not_to eq(current_time)
      expect(@limiter.rules_requests).not_to eq(current_count)       
    end
  end

  describe '#seconds_since_last_rules_reset' do
    before do
      Timecop.freeze(Time.now)
    end
    
    after do
      Timecop.return
    end
    
    it 'returns number of seconds since last reset' do
      Timecop.travel(Time.at(Time.now.to_i + 1))
      expect(@limiter.seconds_since_last_rules_request).to eq(1)
    end
  end
end
