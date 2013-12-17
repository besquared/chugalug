# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'chugalug/version'

Gem::Specification.new do |spec|
  spec.name          = "chugalug"
  spec.version       = Chugalug::VERSION
  spec.authors       = ["Josh Ferguson"]
  spec.email         = ["support@modeanalytics.com"]
  spec.description   = %q{A wrapper around libcsv}
  spec.summary       = %q{A wrapper around libcsv}
  spec.homepage      = "http://www.modeanalytics.com/"
  spec.license       = "MIT"

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  # Development Dependencies
  spec.add_development_dependency "bundler", "~> 1.3"
  spec.add_development_dependency "rake"
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "simplecov"
end
