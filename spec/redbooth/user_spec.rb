require "spec_helper"

describe Redbooth::User do
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
          "id": "1381231",
          "storage":{
            "used": 9207643837,
            "quota": 1100585369600,
            "saved": 14557934927
          },
          "first_name": "Thomas",
          "last_name": "Hunter",
          "developer": true,
          "created_time": 1358175510,
          "email": "thomashunter@example.com",
          "emails": [
            {
              "primary": true,
              "confirmed": true,
              "email": "thomashunter@example.com",
              "gravatar": "eca957c6552e783627a0ced1035e1888"
            },
            {
              "primary": false,
              "confirmed": true,
              "email": "thomashunter@example.net",
              "gravatar": "c0e344ddcbabb383f94b1bd3486e55ba"
            }
          ]
        }
      }
  end
  let (:user) do
    Redbooth::User.new(valid_attributes)
  end

  before :each do
    Redbooth.config do |configuration|
      configuration[:consumer_key] = consumer_key
      configuration[:consumer_secret] = consumer_secret
    end
  end

  describe "#initialize" do
    it 'initializes all attributes correctly' do
      expect(user.email).to eql('thomashunter@example.com')
      expect(user.id).to eql('1381231')
      expect(user.first_name).to eql('Thomas')
      expect(user.last_name).to eql('Hunter')
      expect(user.emails.map {|a| a['email'] }).to eql(%w{thomashunter@example.com thomashunter@example.net})
    end
  end

  describe ".show" do
    let(:user_show) { Redbooth::User.show( session: session ) }
    before :each do
      allow(Redbooth).to receive(:request).and_return(valid_attributes)
    end
    it "makes a new GET request using the correct API endpoint to receive a specific user" do
      expect(Redbooth).to receive(:request).with(:get, nil, "user", {}, { session: session })
      user_show
    end
    it 'returns a user with the correct email' do
      expect(user_show.email).to eql('thomashunter@example.com')
    end
    it 'returns a user with the correct id' do
      expect(user_show.id).to eql('1381231')
    end
    it 'returns a user with the correct first_name' do
      expect(user_show.first_name).to eql('Thomas')
    end
    it 'returns a user with the correct last_name' do
      expect(user_show.last_name).to eql('Hunter')
    end
  end

  describe ".update" do
    let(:update_attributes) do
      {
        first_name: 'New Firt name',
        last_name: 'New Last name'
      }
    end
    let(:user_update) do
      Redbooth::User.update(update_attributes.merge(session: session))
    end
    before :each do
      allow(Redbooth).to receive(:request).and_return(valid_attributes.merge(update_attributes))
    end
    it "makes a new GET request using the correct API endpoint to receive a specific user" do
      expect(Redbooth).to receive(:request).with(:put, nil, "user", update_attributes, { session: session })
      user_update
    end
    it 'returns a user with the correct email' do
      expect(user_update.email).to eql('thomashunter@example.com')
    end
    it 'returns a user with the correct id' do
      expect(user_update.id).to eql('1381231')
    end
    it 'returns a user with the correct first_name' do
      expect(user_update.first_name).to eql('New Firt name')
    end
    it 'returns a user with the correct last_name' do
      expect(user_update.last_name).to eql('New Last name')
    end
  end
end
