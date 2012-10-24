# -*- encoding: utf-8 -*-
$:.push File.expand_path("../lib", __FILE__)
require "gitolite-dtg/version"

Gem::Specification.new do |s|
  s.name        = "gitolite-dtg"
  s.version     = Gitolite::Dtg::VERSION
  s.platform    = Gem::Platform::RUBY
  s.authors     = ["Stafford Brunk", "Lucian Carata"]
  s.email       = ["wingrunr21@gmail.com", "lc525@cam.ac.uk"]
  s.homepage    = "https://github.com/lc525/gitolite-dtg"
  s.summary     = %q{A Ruby gem based on wingrunr21/gitolite for querying the permisions of gitolite repositories.}
  s.description = %q{This gem provides a Ruby read-only interface to the gitolite git backend system (by parsing the configuration file found in the bare gitolite-admin repository).  It aims to enable permission queries based on data written in the gitolite-admin repository. This fork is designed to work as part of a Ruby authorization mechanism to gitolite repositories.}

  s.rubyforge_project = "gitolite-dtg"

  s.add_development_dependency "rspec", "~> 2.9.0"
  s.add_development_dependency "forgery", "~> 0.5.0"
  s.add_development_dependency "rdoc", "~> 3.12"
  s.add_development_dependency "simplecov", "~> 0.6.2"
  s.add_dependency "grit", "~> 2.5.0"
  s.add_dependency "hashery", "~> 1.5.0"
  s.add_dependency "gratr19", "~> 0.4.4.1"

  s.files         = `git ls-files`.split("\n")
  s.test_files    = `git ls-files -- {test,spec,features}/*`.split("\n")
  s.executables   = `git ls-files -- bin/*`.split("\n").map{ |f| File.basename(f) }
  s.require_paths = ["lib"]
end
