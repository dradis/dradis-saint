$:.push File.expand_path('../lib', __FILE__)

# Maintain your gem's version:
require 'dradis/plugins/saint/version'
version = Dradis::Plugins::Saint::VERSION::STRING

# Describe your gem and declare its dependencies:
Gem::Specification.new do |spec|
  spec.platform    = Gem::Platform::RUBY
  spec.name        = 'dradis-saint'
  spec.version     = version
  spec.authors     = ['Daniel Martin']
  spec.homepage    = 'https://dradis.com/integrations/saint.html'
  spec.summary     = 'Saint upload add-on for Dradis Framework.'
  spec.description = 'This add-on allows you to upload and parse reports from Saint.'
  spec.license     = 'GPL-2'

  spec.files = `git ls-files`.split($\)

  spec.add_dependency 'dradis-plugins', '~> 4.0'
  spec.add_dependency 'nokogiri'
  spec.add_dependency 'rake', '~> 13.0'

  spec.add_development_dependency 'bundler', '~> 2.0'
  spec.add_dependency 'combustion', '~> 0.6.0'
  spec.add_dependency 'rspec-rails'
end
