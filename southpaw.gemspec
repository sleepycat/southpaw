# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'southpaw/version'

Gem::Specification.new do |spec|
  spec.name          = "southpaw"
  spec.version       = Southpaw::VERSION
  spec.authors       = ["Mike Williamson"]
  spec.email         = ["mike@korora.ca"]
  spec.summary       = "An experimental Ruby micro-framework"
  spec.description   = "A Ruby micro-framework exploring security and architechtural ideas."
  spec.homepage      = "https://github.com/sleepycat/southpaw"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_runtime_dependency "rack", "~> 1.5"
  spec.add_runtime_dependency "escape_utils", "~> 1.0"
  spec.add_runtime_dependency "uri_template", "~> 0.7"
end
