require 'oauth2'

module RedboothRuby
  class Session

    attr_accessor :token, :refresh_token, :access_token
    attr_accessor :consumer_key, :consumer_secret
    attr_accessor :oauth_verifier, :oauth_token

    OAUTH_URLS =  {
        :site => 'https://redbooth.com/api/3',
        :authorize_url => 'https://redbooth.com/oauth2/authorize',
        :token_url => 'https://redbooth.com/oauth2/token'
    }

    def initialize(opts = {})
      @token = opts[:token]
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
      url = OAUTH_URLS[:request_token_url]
      url += "?oauth_verifier=#{oauth_verifier}" if oauth_verifier
      url += "&oauth_token=#{oauth_token}" if oauth_token
    end

    def access_token
      @access_token ||= OAuth2::AccessToken.new(client, token)
    end

  end
end


