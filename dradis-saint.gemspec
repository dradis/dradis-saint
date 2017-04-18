$:.push File.expand_path("../lib", __FILE__)

# Maintain your gem's version:
require "dradis/saint/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "dradis-saint"
  s.version     = Dradis::Saint::VERSION
  s.authors     = ["Aaron Manaloto"]
  s.email       = ["aaronpomanaloto@gmail.com"]
  s.homepage    = "http://dradisframework.org"
  s.license     = "GPL-2"

  s.files = Dir["{app,config,db,lib}/**/*", "LICENSE", "Rakefile", "README.md"]

  s.add_dependency "rails", "~> 5.0.2"

  s.add_development_dependency "sqlite3"
end
