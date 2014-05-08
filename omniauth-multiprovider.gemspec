$:.push File.expand_path('../lib', __FILE__)
require 'omniauth/multiprovider/version'

Gem::Specification.new do |s|
  s.name        = 'omniauth-multiprovider'
  s.version     = OmniAuth::MultiProvider::VERSION
  s.summary     = "Authenticate devise users with multiple OAuth providers"
  s.description = "Provides a simple approach to support many oauth providers to devise"
  s.authors     = ["German Del Zotto"]
  s.email       = 'germ@ndz.com.ar'
  s.files       = `git ls-files`.split("\n")
  s.require_paths = ['lib']
  s.homepage    = 'https://github.com/1uptalent/omniauth-multiprovider'
  s.license     = 'MIT'

  s.add_dependency('devise', '~> 3.2')
  s.add_dependency('omniauth-oauth2', '~> 1.1')
  s.add_dependency('hashugar', '~> 0.0.6')
end