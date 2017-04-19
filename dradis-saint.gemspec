$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dradis/saint/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dradis-saint"
  s.version     = Dradis::Plugins::Saint::VERSION
  s.authors     = ["Aaron Manaloto"]
  s.email       = ["aaronpomanaloto@gmail.com"]
  s.homepage    = "http://dradisframework.org"
  s.license     = "GPL-2"

  s.files = `git ls-files`.split($\)

  s.add_dependency 'dradis-plugins', '~> 3.6'
  s.add_dependency 'nokogiri'
end
