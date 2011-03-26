# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "version"

Gem::Specification.new do |s|
  s.name        = "capistrano-recipes"
  s.version     = CapistranoRecipes::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Phil Misiowiec", "Leonardo Bighetti"]
  s.email       = ["github@webficient.com"]
  s.homepage    = ""
  s.summary     = %q{Capistrano recipes}
  s.description = %q{Extend the Capistrano gem with these useful recipes}

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = "capistrano-recipes"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]
  
  s.add_dependency "capistrano", ">= 2.5.9"
  s.add_dependency "capistrano-ext", ">= 1.2.1"
end