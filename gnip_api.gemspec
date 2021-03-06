# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'gnip_api/version'

Gem::Specification.new do |spec|
  spec.name          = "gnip_api"
  spec.version       = GnipApi::VERSION
  spec.authors       = ["Rayko"]
  spec.email         = ["rayko.drg@gmail.com"]
  spec.summary       = %q{GnipApi provides exposes all Gnip APIs.}
  spec.description   = %q{GnipApi will allow you to interact with most Gnip APIs and data.}
  spec.homepage      = ""
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0")
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.6"
  spec.add_development_dependency "rake", "~> 13.0"
  spec.add_development_dependency "pry"
  spec.add_development_dependency "awesome_print"       
  spec.add_development_dependency "rspec"
  spec.add_development_dependency "timecop"
  spec.add_development_dependency "byebug"
  spec.add_development_dependency "rdoc"
  spec.add_development_dependency "hanna-nouveau"

  spec.add_dependency "httparty"
  spec.add_dependency "yajl-ruby"
  spec.add_dependency "addressable"
end
