require 'net/http'
require 'net/https'
require 'json'
require 'redbooth-ruby/version'

module RedboothRuby
  DOMAIN_BASE = nil
  API_BASE_PATH = 'api'
  API_VERSION = '3'
  ROOT_PATH   = File.dirname(__FILE__)

  autoload :Base,           'redbooth-ruby/base'
  autoload :Client,         'redbooth-ruby/client'
  autoload :Session,        'redbooth-ruby/session'
  autoload :Me,             'redbooth-ruby/me'
  autoload :User,           'redbooth-ruby/user'
  autoload :Task,           'redbooth-ruby/task'
  autoload :Organization,   'redbooth-ruby/organization'
  autoload :Person,         'redbooth-ruby/person'
  autoload :Project,        'redbooth-ruby/project'
  autoload :Conversation,   'redbooth-ruby/conversation'
  autoload :Membership,     'redbooth-ruby/membership'

  module Operations
    autoload :Base,       'redbooth-ruby/operations/base'
    autoload :Index,      'redbooth-ruby/operations/index'
    autoload :Create,     'redbooth-ruby/operations/create'
    autoload :Delete,     'redbooth-ruby/operations/delete'
    autoload :Show,       'redbooth-ruby/operations/show'
    autoload :Update,     'redbooth-ruby/operations/update'
    autoload :Meta,       'redbooth-ruby/operations/meta'
  end

  module Request
    autoload :Base,       'redbooth-ruby/request/base'
    autoload :Connection, 'redbooth-ruby/request/connection'
    autoload :Helpers,    'redbooth-ruby/request/helpers'
    autoload :Info,       'redbooth-ruby/request/info'
    autoload :Validator,  'redbooth-ruby/request/validator'
    autoload :Response,   'redbooth-ruby/request/response'
    autoload :Collection, 'redbooth-ruby/request/collection'
  end

  class RedboothError < StandardError; end
  class AuthenticationError < RedboothError; end
  class OauhtTokenExpired < AuthenticationError; end
  class OauhtTokenRevoked < AuthenticationError; end
  class NotFound            < RedboothError; end
  class APIError            < RedboothError; end
  class ObjectNotFound      < APIError; end
  class BadRequest     < APIError; end

  # Signals. Usign errors as control flow
  #
  class RedboothSignal < StandardError; end
  class Processing     < RedboothSignal
    attr_accessor :response

    def initialize(response, message='')
      @response = response
      super(message)
    end
  end


  # Gives configuration abilities
  # to setup api_key and api_secret
  #
  # @example
  #   Copy.config do |configuration|
  #     configuration[:api_key] = '_your_api_key'
  #     configuration[:api_secret] = '_your_api_secret'
  #   end
  #
  # @return [String] The api key
  def self.config(&block)
    default_configuration
    yield(@@configuration)
    @@configuration
  end

  def self.configuration
    default_configuration
    @@configuration
  end

  def self.configuration=(value)
    default_configuration
    @@configuration = value
  end

  # Makes a request against the Copy API
  #
  # @param [Symbol] http_method The http method to use, must be one of :get, :post, :put and :delete
  # @param [String] domain The API domain to use
  # @param [String] api_url The API url to use
  # @param [Hash] data The data to send, e.g. used when creating new objects.
  # @return [Array] The parsed JSON response.
  def self.request(http_method, domain, api_url, data, options = {})
    info = Request::Info.new(http_method, domain, api_url, data, options)
    Request::Base.new(info).perform
  end

  def self.default_configuration
    return if defined?(@@configuration)
    @@configuration ||= {}
    @@configuration[:api_base] ||= 'redbooth.com'
    @@configuration[:domain_base] ||= nil
    @@configuration[:api_base_path] ||= 'api'
    @@configuration[:api_version] ||= '3'
    @@configuration[:use_ssl] ||= true
  end
end
