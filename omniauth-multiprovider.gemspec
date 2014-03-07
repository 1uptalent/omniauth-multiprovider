$:.push File.expand_path('../lib', __FILE__)
require 'omniauth/multiprovider/version'

Gem::Specification.new do |s|
  s.name        = 'omniauth-multiprovider'
  s.version     = OmniAuth::MultiProvider::VERSION
  s.summary     = "Authenticate devise users with multiple OAuth providers"
  s.description = "Provides a simple approach to support many oauth providers to devise"
  s.authors     = ["German Del Zotto"]
  s.email       = 'germ@ndz.com.ar'
  s.files       = ["lib/omniauth-multiprovider.rb"]
  s.homepage    = 'http://rubygems.org/gems/omniauth-multiprovider'
  s.license     = 'MIT'

  s.add_runtime_dependency('devise', '~> 3.2')
  s.add_runtime_dependency('omniauth-oauth2', '~> 1.1')
end