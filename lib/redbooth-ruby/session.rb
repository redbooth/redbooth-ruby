require 'oauth2'

module RedboothRuby
  class Session

    attr_accessor :token, :access_token
    attr_accessor :refresh_token, :expires_in, :auto_refresh_token, :on_token_refresh
    attr_accessor :consumer_key, :consumer_secret
    attr_accessor :oauth_verifier, :oauth_token

    OAUTH_URLS =  {
      site: 'https://redbooth.com/api/3',
      authorize_url: 'https://redbooth.com/oauth2/authorize',
      token_url: 'https://redbooth.com/oauth2/token'
    }

    def initialize(opts = {})
      @token = opts[:token]
      @refresh_token = opts[:refresh_token]
      @expires_in = opts[:expires_in]
      @auto_refresh_token = opts[:auto_refresh_token] || true
      @on_token_refresh = opts[:on_token_refresh]
      @consumer_key = opts[:consumer_key] || RedboothRuby.configuration[:consumer_key]
      @consumer_secret = opts[:consumer_secret] || RedboothRuby.configuration[:consumer_secret]
      @oauth_verifier = opts[:oauth_verifier]
      @oauth_token = opts[:oauth_token]
    end

    def valid?
      return false unless token
      true
    end

    def client
      @client ||= OAuth2::Client.new(consumer_key, consumer_secret, OAUTH_URLS)
    end

    def get_access_token_url
      uri = URI.parse(OAUTH_URLS[:token_url])
      params = URI.decode_www_form(uri.query.to_s)
      params << ['oauth_verifier', oauth_verifier] if oauth_verifier
      params << ['oauth_token', oauth_token] if oauth_token
      uri.query = URI.encode_www_form(params) if params.size > 0
      uri.to_s
    end

    def access_token
      @access_token ||= OAuth2::AccessToken.new(client, token,
       refresh_token: refresh_token, expires_in: expires_in)
    end

    def refresh_access_token!
      new_access_token = access_token.refresh!
      if new_access_token
        on_token_refresh.call(access_token, new_access_token) if on_token_refresh.is_a?(Proc)
        @access_token = new_access_token
      end
      new_access_token
    end

    def on_token_refresh(&block)
      if block_given?
        @on_token_refresh = block
      else
        @on_token_refresh
      end
    end
  end
end