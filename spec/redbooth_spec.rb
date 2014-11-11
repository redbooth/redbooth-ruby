require "spec_helper"

describe RedboothRuby do
  describe '.request' do
    context 'given no api key exists' do
      it 'raises an authentication error' do
        expect { RedboothRuby.request(:get, nil, 'clients', {}) }.to raise_error(RedboothRuby::AuthenticationError)
      end
    end

    context "with an invalid api key" do
      let(:consumer_key) { '_your_consumen_key_' }
      let(:consumer_secret) { '_your_consumen_secret_' }
      let(:access_token) do
        {
          token: '_your_user_token_',
          secret: '_your_secret_token_'
        }
      end
      let(:client) { RedboothRuby::Client.new(session) }
      let(:session) { RedboothRuby::Session.new(access_token) }
      let(:redbooth_protocol) { RedboothRuby.configuration[:use_ssl] ? 'https' : 'http' }
      let(:redbooth_url) { "#{redbooth_protocol}://#{RedboothRuby.configuration[:api_base]}/#{RedboothRuby.configuration[:api_base_path]}/#{RedboothRuby.configuration[:api_version]}" }

      before(:each) do
        RedboothRuby.config do |configuration|
          configuration[:consumer_key] = consumer_key
          configuration[:consumer_secret] = consumer_secret
        end
        WebMock.stub_request(:any,
                             /#{RedboothRuby.configuration[:api_base]}/
                            ).to_return(body: '{}')
      end

      it 'attempts to get a url with one param' do
        RedboothRuby.request(:get, nil, 'user',
                     { param_name: 'param_value' },
                     { session: session }
                    )
        expect(WebMock).to have_requested(:get,
                                      "#{redbooth_url}/user?param_name=param_value"
                                      )
      end

      it 'attempts to get a url with more than one param' do
        RedboothRuby.request(:get,
                         nil,
                         'user',
                         { client: 'client_id', order: 'created_at_desc' },
                         { session: session }
                        )
        expect(WebMock).to have_requested(
          :get,
          "#{redbooth_url}/user?client=client_id&order=created_at_desc"
        )
      end

      it "doesn't add a question mark if no params" do
        RedboothRuby.request(:post, nil, "user", {}, { session: session })
        expect(WebMock).to have_requested(:post, "#{redbooth_url}/user")
      end

      it "uses the param id to construct the url" do
        RedboothRuby.request(:post, nil, "user", {id: 'new_id'}, { session: session })
        expect(WebMock).to have_requested(:post, "#{redbooth_url}/user/new_id")
      end
    end
  end
end
