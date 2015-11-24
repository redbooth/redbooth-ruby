require 'spec_helper'

describe RedboothRuby::ClientOperations::Perform do
  let(:access_token) do
    {
      token: '_your_user_token_',
      secret: '_your_secret_token_',
      refresh_token: '_your_user_reset_token_'
    }
  end
  let(:session) { RedboothRuby::Session.new(access_token) }
  let(:performer) { RedboothRuby::ClientOperations::Perform.new(:user, :show, session) }

  describe '#initialize' do
    subject { performer }

    it { expect(performer.resource_name).to eql(:user) }
    it { expect(performer.action).to eql(:show) }
    it { expect(performer.session).to eql(session) }
  end

  describe '#perform!' do
    it 'raises RedboothRuby::AuthenticationError if session is invalid' do
      allow(performer).to receive(:session).and_return(nil)
      expect { performer.perform! }.to raise_error(RedboothRuby::AuthenticationError)
    end
    it 'calls to the given resource' do
      allow(RedboothRuby::User).to receive(:show).and_return(RedboothRuby::User.new)
      expect(RedboothRuby::User).to receive(:show).with(session: session)

      performer.perform!
    end

    context 'oauth token expired' do
      before do
        allow(RedboothRuby::User).to receive(:show).and_raise(RedboothRuby::OauthTokenExpired)
      end
      it 'tries to refresh access_token' do
        allow(session).to receive(:refresh_access_token!).and_return({})
        expect(session).to receive(:refresh_access_token!)
        expect{ performer.perform! }.to raise_error(RedboothRuby::OauthTokenExpired)
      end
      it 'raise error if `refresh_access_token` fails' do
        allow(session).to receive(:refresh_access_token!).and_return(nil)
        expect{ performer.perform! }.to raise_error(RedboothRuby::OauthTokenExpired)
      end
      it 'raise error if `auto_refresh_token` is disabled' do
        session.auto_refresh_token = false
        expect{ performer.perform! }.to raise_error(RedboothRuby::OauthTokenExpired)
      end
    end
  end

  describe '#perform_processing!' do
    let(:processing) do
      RedboothRuby::Processing.new(OpenStruct.new(data: { 'retry_after' => '0' }))
    end
    it 'delays the processing' do
      allow(performer).to receive(:processing_error).and_return(processing)
      allow(performer).to receive(:perform!).and_return(nil)
      expect(performer).to receive(:perform!).once
      performer.perform_processing!
    end
    it 'retries the the processing' do
      allow(performer).to receive(:processing_error).and_return(processing)
      expect(performer).to receive(:retry_in).with(0)
      performer.perform_processing!
    end
    it 'use 10 seconds as default delay' do
      expect(performer).to receive(:retry_in).with(10)
      performer.perform_processing!
    end
  end

  describe '#perform_oauth_token_expired!' do
    let(:oauth_token_expired_error) { RedboothRuby::OauthTokenExpired.new }
    before do
      allow(performer).to receive(:oauth_token_expired_error).and_return(oauth_token_expired_error)
    end

    context 'when it\'s the first attempt and refresh access token present' do
      before do
        allow(performer.session).to receive(:refresh_access_token!).and_return({})
        allow(performer).to receive(:tries).and_return(1)
      end
      it 'refreshes the session access token' do
        allow(performer).to receive(:perform!)
        allow(performer).to receive(:refresh_session_access_token!).and_return(true)
        expect(performer).to receive(:refresh_session_access_token!).once
        performer.perform_oauth_token_expired!
      end
      it 'retries the processing' do
        expect(performer).to receive(:perform!).once
        performer.perform_oauth_token_expired!
      end
    end

    context 'raising the exception' do
      it 'when the number of tries is not 1' do
        allow(performer).to receive(:tries).and_return(2)
        expect{ performer.perform_oauth_token_expired! }.to raise_error(oauth_token_expired_error)
      end

      it 'when refresh access token is nil' do
        allow(performer.session).to receive(:refresh_access_token!).and_return(nil)
        expect{ performer.perform_oauth_token_expired! }.to raise_error(oauth_token_expired_error)
      end
    end
  end

  describe '#options_with_session' do
    it 'adds the session to the given options' do
      expect(performer.send(:options_with_session, {})).to include(:session)
      expect(performer.send(:options_with_session, {})[:session]).to eql(session)
    end
  end

  describe '#resource' do
    it 'gives the correct api resource class' do
      expect(performer.send(:resource, 'user')).to eql(RedboothRuby::User)
    end
    it 'gives nil if there is no resource for the given name' do
      expect(performer.send(:resource, 'icecream')).to be_nil
    end
  end
end
