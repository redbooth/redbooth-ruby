require 'net/http'
require 'net/https'
require 'json'
require 'redbooth/version'

module Redbooth
  DOMAIN_BASE = nil
  API_BASE    = 'redbooth.com'
  API_BASE_PATH = 'api'
  API_VERSION = '3'
  ROOT_PATH   = File.dirname(__FILE__)

  @@configuration = {}

  autoload :Base,           'redbooth/base'
  autoload :Client,         'redbooth/client'
  autoload :Session,        'redbooth/session'
  autoload :Me,             'redbooth/me'
  autoload :User,           'redbooth/user'

  module Operations
    autoload :Base,       'redbooth/operations/base'
    autoload :All,        'redbooth/operations/all'
    autoload :Create,     'redbooth/operations/create'
    autoload :Delete,     'redbooth/operations/delete'
    autoload :Find,       'redbooth/operations/find'
    autoload :Show,       'redbooth/operations/show'
    autoload :Update,     'redbooth/operations/update'
    autoload :Meta,       'redbooth/operations/meta'
  end

  module Request
    autoload :Base,       'redbooth/request/base'
    autoload :Connection, 'redbooth/request/connection'
    autoload :Helpers,    'redbooth/request/helpers'
    autoload :Info,       'redbooth/request/info'
    autoload :Validator,  'redbooth/request/validator'
  end

  class RedboothError < StandardError; end
  class AuthenticationError < RedboothError; end
  class NotFound            < RedboothError; end
  class APIError            < RedboothError; end
  class ObjectNotFound      < APIError; end
  class BadRequest     < APIError; end


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
    yield(@@configuration)
    @@configuration
  end

  def self.configuration
    @@configuration
  end

  def self.configuration=(value)
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
end
