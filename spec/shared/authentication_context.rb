shared_context 'authentication' do
  let(:use_development?) { true }
  let(:consumer_key) { use_development? ? '_redbooth_development_' : ENV['CLIENT_ID'] }
  let(:consumer_secret) { use_development? ? '_redbooth_development_' : ENV['CLIENT_SECRET'] }
  let(:access_token) do
    {
      token: use_development? ? '_frank_access_token_' : ENV['ACCESS_TOKEN'] ,
      refresh_token: use_development? ? '_frank_refresh_token_' : ENV['REFRESH_TOKEN']
    }
  end
  let(:client) { RedboothRuby::Client.new(session) }
  let(:session) { RedboothRuby::Session.new(access_token) }

  before :each do
    RedboothRuby.config do |configuration|
      if use_development?
        configuration[:api_base] = 'localhost:3000'
        configuration[:use_ssl] = false
      end
      configuration[:consumer_key] = consumer_key
      configuration[:consumer_secret] = consumer_secret
    end
  end
end
