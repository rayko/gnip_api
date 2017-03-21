require 'spec_helper'

describe Gnip::Message do
  describe '.build' do
    context 'weird message' do
      before do
        @message = {'lolcat' => 'madcat'}
      end

      it 'raises Undefinedmessage exception' do
        expect(Proc.new{Gnip::Message.build(@message)}).to raise_error(Gnip::UndefinedMessage)
      end
    end

    context 'activity' do
      before do
        @activity = JSON.parse File.read(fixture_path.join('activities', 'real_activity.json'))
      end
      
      it 'recognizes activity' do
        expect(Proc.new{Gnip::Message.build(@activity)}).not_to raise_error
        expect(Gnip::Message.build(@activity).class).to eq(Gnip::Activity)
      end
    end

    context 'twitter compliance message' do
      it 'parses status delete as twitter compliance message' do
        data = JSON.parse File.read(fixture_path.join('twitter_messages', 'status_delete.json'))
        message = Gnip::Message.build(data)
        expect(message.class).to eq(Gnip::TwitterComplianceMessage)
      end

      it 'parses user delete as twitter compliance message' do
        data = JSON.parse File.read(fixture_path.join('twitter_messages', 'user_delete.json'))
        message = Gnip::Message.build(data)
        expect(message.class).to eq(Gnip::TwitterComplianceMessage)
      end

      it 'parses user undelete as twitter compliance message' do
        data = JSON.parse File.read(fixture_path.join('twitter_messages', 'user_undelete.json'))
        message = Gnip::Message.build(data)
        expect(message.class).to eq(Gnip::TwitterComplianceMessage)
      end

      it 'parses scrub geo as twitter compliance message' do
        data = JSON.parse File.read(fixture_path.join('twitter_messages', 'scrub_geo.json'))
        message = Gnip::Message.build(data)
        expect(message.class).to eq(Gnip::TwitterComplianceMessage)
      end

      it 'parses user protect as twitter compliance message' do
        data = JSON.parse File.read(fixture_path.join('twitter_messages', 'user_protect.json'))
        message = Gnip::Message.build(data)
        expect(message.class).to eq(Gnip::TwitterComplianceMessage)
      end

      it 'parses user unprotect as twitter compliance message' do
        data = JSON.parse File.read(fixture_path.join('twitter_messages', 'user_unprotect.json'))
        message = Gnip::Message.build(data)
        expect(message.class).to eq(Gnip::TwitterComplianceMessage)
      end

      it 'parses user suspend as twitter compliance message' do
        data = JSON.parse File.read(fixture_path.join('twitter_messages', 'user_suspend.json'))
        message = Gnip::Message.build(data)
        expect(message.class).to eq(Gnip::TwitterComplianceMessage)
      end

      it 'parses user unsuspend as twitter compliance message' do
        data = JSON.parse File.read(fixture_path.join('twitter_messages', 'user_unsuspend.json'))
        message = Gnip::Message.build(data)
        expect(message.class).to eq(Gnip::TwitterComplianceMessage)
      end

      it 'parses user withheld as twitter compliance message' do
        data = JSON.parse File.read(fixture_path.join('twitter_messages', 'user_withheld.json'))
        message = Gnip::Message.build(data)
        expect(message.class).to eq(Gnip::TwitterComplianceMessage)
      end

      it 'parses status withheld as twitter compliance message' do
        data = JSON.parse File.read(fixture_path.join('twitter_messages', 'status_withheld.json'))
        message = Gnip::Message.build(data)
        expect(message.class).to eq(Gnip::TwitterComplianceMessage)
      end



    end
    
    context 'system_message' do
      before do
        @error = JSON.parse File.read(fixture_path.join('system_messages', 'error.json'))
        @warn = JSON.parse File.read(fixture_path.join('system_messages', 'warn.json'))
        @info = JSON.parse File.read(fixture_path.join('system_messages', 'info.json'))
      end
      it 'recognizes error message' do
        expect(Proc.new{Gnip::Message.build(@error)}).not_to raise_error
        expect(Gnip::Message.build(@error).class).to eq(Gnip::SystemMessage)
      end

      it 'recognizes warn message' do
        expect(Proc.new{Gnip::Message.build(@warn)}).not_to raise_error
        expect(Gnip::Message.build(@warn).class).to eq(Gnip::SystemMessage)
      end

      it 'recognizes info message' do
        expect(Proc.new{Gnip::Message.build(@info)}).not_to raise_error
        expect(Gnip::Message.build(@info).class).to eq(Gnip::SystemMessage)
      end
    end
  end
end
