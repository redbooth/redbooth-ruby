require 'spec_helper'

describe RedboothRuby::Session, vcr: 'session' do
  let(:token) { '_your_user_token_' }
  let(:refresh_token) { '_your_user_refresh_token_' }
  let(:expires_in) { 7200 }
  let(:auto_refresh_token) { true }
  let(:consumer_key) { '_your_consumer_key_' }
  let(:consumer_secret) { '_your_consumer_secret_' }
  let(:session) do
    RedboothRuby::Session.new(token: token, refresh_token: refresh_token,
      expires_in: expires_in, auto_refresh_token: auto_refresh_token,
      consumer_key: consumer_key, consumer_secret: consumer_secret)
  end

  describe '#initialize' do
    subject { session }

    it { expect(session.token).to eql token }
    it { expect(session.refresh_token).to eql refresh_token }
    it { expect(session.expires_in).to eql expires_in }
    it { expect(session.auto_refresh_token).to eql auto_refresh_token }
    it { expect(session.consumer_key).to eql consumer_key }
    it { expect(session.consumer_secret).to eql consumer_secret }
  end

  describe '#valid?' do
    subject { session.valid? }
    it { should eql true }

    context 'when token is empty' do
      before { session.token = nil }
      it { should eql false }
    end
  end

  describe '#client' do
    subject(:client) { session.client }
    it { should be_a OAuth2::Client }
    it { expect(client.id).to eql consumer_key }
    it { expect(client.secret).to eql consumer_secret }
  end

  describe '#get_access_token_url' do
    subject { session.get_access_token_url }
    it { should eql 'https://redbooth.com/oauth2/token' }

    context 'when oauth_verifier is present' do
      before { session.oauth_verifier = '_your_user_oauth_verifier_token_' }
      it { should eql 'https://redbooth.com/oauth2/token?oauth_verifier=_your_user_oauth_verifier_token_' }
    end

    context 'when oauth_token is present' do
      before { session.oauth_token = '_your_user_oauth_token_' }
      it { should eql 'https://redbooth.com/oauth2/token?oauth_token=_your_user_oauth_token_' }
    end

    context 'when oauth_verifier and oauth_token are present' do
      before do
        session.oauth_verifier = '_your_user_oauth_verifier_token_'
        session.oauth_token = '_your_user_oauth_token_'
      end
      it { should eql 'https://redbooth.com/oauth2/token?oauth_verifier=_your_user_oauth_verifier_token_&oauth_token=_your_user_oauth_token_' }
    end
  end

  describe '#access_token' do
    subject(:access_token) { session.access_token }
    it { should be_a OAuth2::AccessToken }
    it { expect(access_token.client).to eql session.client }
    it { expect(access_token.token).to eql session.token }
    it { expect(access_token.refresh_token).to eql session.refresh_token }
    it { expect(access_token.expires_in).to eql session.expires_in }
  end

  describe '#refresh_access_token!' do
    context 'updates intance variables' do
      before { session.refresh_access_token! }
      it { expect(session.token).to eql('_your_new_user_token_') }
      it { expect(session.refresh_token).to eql('_your_new_user_refresh_token_') }
      it { expect(session.expires_in).to eql(7200) }
    end

    context 'refreshes the access_token' do
      before { session.refresh_access_token! }
      it { expect(session.access_token.token).to eql('_your_new_user_token_') }
      it { expect(session.access_token.refresh_token).to eql('_your_new_user_refresh_token_') }
    end

    it 'call `on_token_refresh` with the old and new token' do
      on_token_refresh = Proc.new { |old_token, new_token| }
      session.on_token_refresh = on_token_refresh

      allow(on_token_refresh).to receive(:call) do |old_token, new_token|
        expect(old_token.token).to eql('_your_user_token_')
        expect(old_token.refresh_token).to eql('_your_user_refresh_token_')

        expect(new_token.token).to eql('_your_new_user_token_')
        expect(new_token.refresh_token).to eql('_your_new_user_refresh_token_')
      end

      session.refresh_access_token!
    end
  end
end