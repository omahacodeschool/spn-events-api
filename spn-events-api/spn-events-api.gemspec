# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spn/events/api/version'

Gem::Specification.new do |spec|
  spec.name          = "spn-events-api"
  spec.version       = Spn::Events::Api::VERSION
  spec.authors       = ["“Kyle Schmit && Matt Taylor"]
  spec.email         = ["kschmit90@gmail.com"]
  spec.summary       = %q{This is a web scraping API which gathers information about events in the Silicon Prairie.}
  spec.description   = %q{TODO: Write a longer description. Optional.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
end
