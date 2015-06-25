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
