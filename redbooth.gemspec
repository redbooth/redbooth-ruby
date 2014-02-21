# -*- encoding: utf-8 -*-
$:.push File.expand_path('../lib', __FILE__)
require 'redbooth/version'

Gem::Specification.new do |s|
  s.name        = 'redbooth-ruby'
  s.version     = Redbooth::VERSION
  s.authors     = ['Andres Bravo', 'Carlos Saura']
  s.email       = ['support@redbooth.com']
  s.homepage    = 'https://github.com/teambox/redbooth-ruby'
  s.summary     = %q{API wrapper for Redbooth.}
  s.description = %q{API wrapper for Redbooth.}

  s.files         = `git ls-files`.split('\n')
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split('\n')
  s.executables   = `git ls-files -- bin/*`.split('\n').map{ |f| File.basename(f) }
  s.require_paths = ['lib']

  s.add_dependency 'json'
  s.add_dependency 'oauth2'
  s.add_dependency(%q<multipart-post>, ['>= 1.1.0'])

  s.add_development_dependency 'rspec'
  s.add_development_dependency 'pry'
end
