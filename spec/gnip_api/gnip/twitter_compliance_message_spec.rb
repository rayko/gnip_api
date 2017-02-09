require 'spec_helper'

describe Gnip::TwitterComplianceMessage do
  describe '.new' do
    it 'parses status delete message' do
      data = JSON.parse File.read(fixture_path.join('twitter_messages', 'status_delete.json'))
      expect(Proc.new{Gnip::TwitterComplianceMessage.new(data)}).not_to raise_error
    end

    it 'parses user delete message' do
      data = JSON.parse File.read(fixture_path.join('twitter_messages', 'user_delete.json'))
      expect(Proc.new{Gnip::TwitterComplianceMessage.new(data)}).not_to raise_error
    end

    it 'parses user undelete message' do
      data = JSON.parse File.read(fixture_path.join('twitter_messages', 'user_undelete.json'))
      expect(Proc.new{Gnip::TwitterComplianceMessage.new(data)}).not_to raise_error
    end

    it 'parses scrub geo message' do
      data = JSON.parse File.read(fixture_path.join('twitter_messages', 'scrub_geo.json'))
      expect(Proc.new{Gnip::TwitterComplianceMessage.new(data)}).not_to raise_error
    end

    it 'parses user protect message' do
      data = JSON.parse File.read(fixture_path.join('twitter_messages', 'user_protect.json'))
      expect(Proc.new{Gnip::TwitterComplianceMessage.new(data)}).not_to raise_error
    end

    it 'parses user unprotect message' do
      data = JSON.parse File.read(fixture_path.join('twitter_messages', 'user_unprotect.json'))
      expect(Proc.new{Gnip::TwitterComplianceMessage.new(data)}).not_to raise_error
    end

    it 'parses user suspend message' do
      data = JSON.parse File.read(fixture_path.join('twitter_messages', 'user_suspend.json'))
      expect(Proc.new{Gnip::TwitterComplianceMessage.new(data)}).not_to raise_error
    end

    it 'parses user unsuspend message' do
      data = JSON.parse File.read(fixture_path.join('twitter_messages', 'user_unsuspend.json'))
      expect(Proc.new{Gnip::TwitterComplianceMessage.new(data)}).not_to raise_error
    end

    it 'parses user withheld message' do
      data = JSON.parse File.read(fixture_path.join('twitter_messages', 'user_withheld.json'))
      expect(Proc.new{Gnip::TwitterComplianceMessage.new(data)}).not_to raise_error
    end

    it 'parses status withheld message' do
      data = JSON.parse File.read(fixture_path.join('twitter_messages', 'status_withheld.json'))
      expect(Proc.new{Gnip::TwitterComplianceMessage.new(data)}).not_to raise_error
    end

  end
end
