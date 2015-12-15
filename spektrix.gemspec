# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'spektrix/version'

Gem::Specification.new do |spec|
  spec.name          = "spektrix"
  spec.version       = Spektrix::VERSION
  spec.authors       = ["Ed Jones", "Paul Hendrick"]
  spec.email         = ["hosting@error.agency"]
  spec.summary       = %q{A client library for the Spektrix ticketing system}
  spec.description   = %q{A client library for the Spektrix ticketing system. Requires a Spektrix user account.}
  spec.homepage      = "https://github.com/errorstudio/spektrix-ruby"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake"

  spec.add_dependency "her", "~> 0.8"
end
