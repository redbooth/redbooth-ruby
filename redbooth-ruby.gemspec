# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'redbooth-ruby/version'

Gem::Specification.new do |s|
  s.name        = 'redbooth-ruby'
  s.version     = RedboothRuby::VERSION
  s.authors     = ['Andres Bravo', 'Carlos Saura', 'Bruno Pedro', 'Oscar Ferrer', 'Ivan Ilves']
  s.email       = ['support@redbooth.com']
  s.homepage    = 'https://github.com/teambox/redbooth-ruby'
  s.summary     = 'API wrapper for Redbooth.'
  s.description = s.summary

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {spec}/*`.split("\n")
  s.require_paths = ['lib']

  s.required_ruby_version = '>= 1.9.3'

  s.add_dependency 'json', '~> 1.8'
  s.add_dependency 'oauth2', '>= 0.8'
  s.add_dependency 'multipart-post', '~> 2.0'

  s.add_development_dependency 'rspec', '~> 3.4'
  s.add_development_dependency 'pry', '~> 0.10'
  s.add_development_dependency 'vcr', '~> 3.0'
  s.add_development_dependency 'rake', '~> 10.4'
  s.add_development_dependency 'webmock', '~> 1.22'
  s.add_development_dependency 'rack-test', '~> 0.6'
  s.add_development_dependency 'codeclimate-test-reporter', '~> 0.4'
end
