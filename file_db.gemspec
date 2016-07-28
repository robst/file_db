# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'file_db/version'

Gem::Specification.new do |spec|
  spec.name          = "file_db"
  spec.version       = FileDb::VERSION
  spec.authors       = ["Robert Starke"]
  spec.email         = ["robertst81@gmail.com"]

  spec.summary       = %q{Use CSV Files like a Database with ActiveRecord Feeling.}
  spec.description   = %q{You need to store informationen in a CSV File, because there is no need for a database? You can use FileDb to store all informationen in a CSV File and search in it like ActiveRecord (User.find(1212). See detailed Information at the github Page.}
  spec.homepage      = "https://github.com/robst/file_db"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.12"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.required_ruby_version = '>= 1.9.3'
end
