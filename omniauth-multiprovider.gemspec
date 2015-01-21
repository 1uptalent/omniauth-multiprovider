# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'omniauth/multiprovider/version'

Gem::Specification.new do |s|
  s.name        = 'omniauth-multiprovider'
  s.version     = OmniAuth::MultiProvider::VERSION
  s.summary     = "Authenticate devise users with multiple OAuth providers"
  s.description = "Provides a simple approach to support many oauth providers to devise"
  s.authors     = ["German Del Zotto"]
  s.email       = 'germ@ndz.com.ar'
  s.files       = `git ls-files -z`.split("\x0")
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']
  s.homepage    = 'https://github.com/1uptalent/omniauth-multiprovider'
  s.license     = 'MIT'

  s.add_dependency('devise', '~> 3.2')
  s.add_dependency('activesupport', ">= 3.2.6", "< 5")
  s.add_dependency('activerecord', ">= 3.2.6", "< 5")
  s.add_dependency('omniauth-oauth2', '~> 1.1')
  s.add_dependency('hashugar', '~> 0.0', '>= 0.0.6')

  s.add_development_dependency "bundler", "~> 1.7"
  s.add_development_dependency "rake", "~> 10.0"

  s.add_development_dependency "rspec", "~> 3.1"
  s.add_development_dependency "rspec-rails", "~> 3.1"
  s.add_development_dependency "sqlite3"
end
