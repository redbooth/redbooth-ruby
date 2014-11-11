require "spec_helper"

describe RedboothRuby::Request::Connection do
  let(:consumer_key) { '_your_consumen_key_' }
  let(:consumer_secret) { '_your_consumen_secret_' }
  let(:access_token) do
    {
      token: '_your_user_token_',
      secret: '_your_secret_token_'
    }
  end
  let(:connection) { RedboothRuby::Request::Connection.new(info) }
  let(:info) do
    RedboothRuby::Request::Info.new(:get,
                                nil,
                                'user',
                                {},
                                { session: session }
                               )
  end
  let(:client) { RedboothRuby::Client.new(session) }
  let(:session) { RedboothRuby::Session.new(access_token) }
  let(:redbooth_protocol) { RedboothRuby.configuration[:use_ssl] ? 'https' : 'http' }
  let(:redbooth_url) { "#{redbooth_protocol}://#{RedboothRuby.configuration[:api_base]}/#{RedboothRuby.configuration[:api_base_path]}/#{RedboothRuby.configuration[:api_version]}" }

  before :each do
    RedboothRuby.config do |configuration|
      configuration[:consumer_key] = consumer_key
      configuration[:consumer_secret] = consumer_secret
    end
  end

  describe '#set_request_data' do
    it 'creates a request_data object' do
      connection.set_request_data

      expect(connection.request_data).to_not be_nil
    end
  end

  describe '#request' do
    it 'performs the actual request' do
      connection.set_request_data
      allow(connection).to receive(:set_request_data)

      expect(connection.access_token).to receive(:send).with(*connection.request_data)

      connection.request
    end
  end

  describe '#request_data' do
    it 'correctly formats the form data' do
      info = double(
        http_method: :post,
        url: '/some/path',
        data: params,
        subdomain: RedboothRuby::DOMAIN_BASE,
        session: session
      )
      connection = RedboothRuby::Request::Connection.new(info)
      connection.set_request_data

      expect(connection.request_data).to eq(
        [
          :post,
          "#{redbooth_url}/some/path",
          { body: { email: "abc_abc.com",
                    event_types: ["user.created", "user.failed", "team.created", "documents.available"] }
          }
        ]
      )
    end
  end

  def params
    {
      email: "abc_abc.com",
      event_types: ["user.created","user.failed", "team.created", "documents.available"]
    }
  end
end
