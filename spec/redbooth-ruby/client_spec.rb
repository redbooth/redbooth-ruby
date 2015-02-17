require 'spec_helper'

describe RedboothRuby::Client do
  let(:access_token) do
    {
      token: '_your_user_token_',
      secret: '_your_secret_token_'
    }
  end
  let(:client) { RedboothRuby::Client.new(session) }
  let(:session) { RedboothRuby::Session.new(access_token) }
  let(:valid_attributes) { JSON.parse('{}') }

  before :each do
    allow(RedboothRuby).to receive(:request).and_return(valid_attributes)
  end

  describe '#initialize' do
    it 'initializes attributes correctly' do
      expect(client.session).to eql(session)
    end
    it 'raises RedboothRuby::AuthenticationError if session is invalid' do
      allow(session).to receive(:valid?).and_return(false)

      expect{client}.to raise_error{ RedboothRuby::AuthenticationError }
    end
  end
end