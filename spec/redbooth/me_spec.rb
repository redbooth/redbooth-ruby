require "spec_helper"

describe Redbooth::Me do
  let(:consumer_key) { '_your_consumen_key_' }
  let(:consumer_secret) { '_your_consumen_secret_' }
  let(:access_token) do
    {
      token: '_your_user_token_',
      secret: '_your_secret_token_'
    }
  end
  let(:client) { Redbooth::Client.new(session) }
  let(:session) { Redbooth::Session.new(access_token) }
  let(:valid_attributes) do
      JSON.parse %{
        {
          "id": "me",
          "email": "yo@gmail.com",
          "first_name": "Frank",
          "last_name": "Krammer"
        }
      }
  end
  let(:me) do
    Redbooth::Me.new(valid_attributes)
  end

  before :each do
    Redbooth.config do |configuration|
      configuration[:consumer_key] = consumer_key
      configuration[:consumer_secret] = consumer_secret
    end
  end

  describe '#initialize' do
    it 'initializes all attributes correctly' do
      expect(me.email).to eql('yo@gmail.com')
      expect(me.id).to eql('me')
      expect(me.first_name).to eql('Frank')
      expect(me.last_name).to eql('Krammer')
    end
  end

  describe '.show' do
    let(:me_show) { Redbooth::Me.show(id: '/', session: session) }
    before :each do
      allow(Redbooth).to receive(:request).and_return(valid_attributes)
    end
    it 'makes a new GET request using the correct API endpoint to receive a specific user' do
      expect(Redbooth).to receive(:request).with(:get,
                                             nil,
                                             'me',
                                             {},
                                             { session: session }
                                            )
      me_show
    end
    it 'returns a file with the correct email' do
      expect(me_show.email).to eql('yo@gmail.com')
    end
    it 'returns a file with the correct id' do
      expect(me_show.id).to eql('me')
    end
    it 'returns a file with the correct first_name' do
      expect(me_show.first_name).to eql('Frank')
    end
    it 'returns a file with the correct last_name' do
      expect(me_show.last_name).to eql('Krammer')
    end
  end
end
