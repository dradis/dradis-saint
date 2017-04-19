$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dradis/plugins/saint/version"
version = Dradis::Plugins::Saint::VERSION::STRING

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.platform    = Gem::Platform::RUBY
  s.name        = "dradis-saint"
  s.version     = version
  s.authors     = ["Aaron Manaloto"]
  s.email       = ["aaronpomanaloto@gmail.com"]
  s.homepage    = "http://dradisframework.org"
  s.summary     = "Saint upload add-on for Dradis Framework."
  s.description = "This add-on allows you to upload and parse reports from Saint."
  s.license     = "GPL-2"

  s.files = `git ls-files`.split($\)

  s.add_dependency 'dradis-plugins', '~> 3.6'
  s.add_dependency 'nokogiri'
end
