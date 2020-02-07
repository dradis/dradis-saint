$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'dradis/plugins/saint/version'
version = Dradis::Plugins::Saint::VERSION::STRING

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = 'dradis-saint'
  s.version     = version
  s.authors     = ['Daniel Martin']
  s.email       = ['etd@nomejortu.com']
  s.homepage    = 'http://dradisframework.org'
  s.summary     = 'Saint upload add-on for Dradis Framework.'
  s.description = 'This add-on allows you to upload and parse reports from Saint.'
  s.license     = 'GPL-2'

  s.files = `git ls-files`.split($\)

  s.add_dependency 'dradis-plugins', '~> 3.8'
  s.add_dependency 'nokogiri'
  s.add_dependency 'rake', '~> 13.0'

  s.add_development_dependency 'bundler', '~> 1.6'
  s.add_dependency 'combustion', '~> 0.6.0'
  s.add_dependency 'rspec-rails'
end
