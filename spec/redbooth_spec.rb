require "spec_helper"

describe Redbooth do
  describe '.request' do
    context 'given no api key exists' do
      it 'raises an authentication error' do
        expect { Redbooth.request(:get, nil, 'clients', {}) }.to raise_error(Redbooth::AuthenticationError)
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
      let(:client) { Redbooth::Client.new(session) }
      let(:session) { Redbooth::Session.new(access_token) }
      let(:redbooth_protocol) { Redbooth.configuration[:use_ssl] ? 'https' : 'http' }
      let(:redbooth_url) { "#{redbooth_protocol}://#{Redbooth.configuration[:api_base]}/#{Redbooth.configuration[:api_base_path]}/#{Redbooth.configuration[:api_version]}" }

      before(:each) do
        Redbooth.config do |configuration|
          configuration[:consumer_key] = consumer_key
          configuration[:consumer_secret] = consumer_secret
        end
        WebMock.stub_request(:any,
                             /#{Redbooth.configuration[:api_base]}/
                            ).to_return(body: '{}')
      end

      it 'attempts to get a url with one param' do
        Redbooth.request(:get, nil, 'user',
                     { param_name: 'param_value' },
                     { session: session }
                    )
        WebMock.should have_requested(:get,
                                      "#{redbooth_url}/user?param_name=param_value"
                                      )
      end

      it 'attempts to get a url with more than one param' do
        Redbooth.request(:get,
                         nil,
                         'user',
                         { client: 'client_id', order: 'created_at_desc' },
                         { session: session }
                        )
        WebMock.should have_requested(
          :get,
          "#{redbooth_url}/user?client=client_id&order=created_at_desc"
        )
      end

      it "doesn't add a question mark if no params" do
        Redbooth.request(:post, nil, "user", {}, { session: session })
        WebMock.should have_requested(:post, "#{redbooth_url}/user")
      end

      it "uses the param id to construct the url" do
        Redbooth.request(:post, nil, "user", {id: 'new_id'}, { session: session })
        WebMock.should have_requested(:post, "#{redbooth_url}/user/new_id")
      end
    end
  end
end
