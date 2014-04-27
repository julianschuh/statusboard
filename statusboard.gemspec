# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'statusboard/version'

Gem::Specification.new do |spec|
  spec.name          = "statusboard"
  spec.version       = Statusboard::VERSION
  spec.authors       = ["Julian Schuh"]
  spec.email         = ["julez@julez.in"]
  spec.summary       = %q{Generate data for the Status Board App by Panic.}
  spec.description   = %q{Generate data that is compatible with the Status Board app by Panic using a convenient DSL.}
  spec.homepage      = "http://julez.io"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "sinatra", "~> 1.4.5"

  spec.add_dependency "tilt", ">= 1.4.0"          # Simple Template parsing
  spec.add_dependency "rack-handlers", "~> 0.7"   # Rack handler
end
