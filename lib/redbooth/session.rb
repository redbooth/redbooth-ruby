require 'oauth'

module Redbooth
  class Session

    attr_accessor :token, :secret, :access_token
    attr_accessor :consumer_key, :consumer_secret
    attr_accessor :oauth_verifier, :oauth_token

    OAUTH_URLS =  {
        :site => 'https://redbooth.com/api/3',
        :authorize_url => 'https://redbooth.com/oauth2/authorize',
        :token_url => 'https://redbooth.com/oauth2/token'
    }

    def initialize(opts = {})
      @secret = opts[:secret]
      @token = opts[:token]
      @consumer_secret = opts[:secret]
      @consumer_key = opts[:consumer_key] || Redbooth.configuration[:consumer_key]
      @consumer_secret = opts[:consumer_secret] || Redbooth.configuration[:consumer_secret]
      @oauth_verifier = opts[:oauth_verifier]
      @oauth_token = opts[:oauth_token]
    end

    def valid?
      return false unless token
      return false unless secret
      true
    end

    def consumer
      @consumer ||= OAuth::Consumer.new(consumer_key, consumer_secret,
        :site => OAUTH_URLS[:site]
        # :authorize_url => OAUTH_URLS[:authorize_url],
        # :request_token_url => OAUTH_URLS[:request_token_url],
        # :access_token_url =>  get_access_token_url
      )
    end

    def get_access_token_url
      url = OAUTH_URLS[:request_token_url]
      url += "?oauth_verifier=#{oauth_verifier}" if oauth_verifier
      url += "&oauth_token=#{oauth_token}" if oauth_token
    end

    def access_token
      @access_token ||= OAuth::AccessToken.new(consumer, token, secret)
    end

  end
end


