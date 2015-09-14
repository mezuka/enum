# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'enum/version'

Gem::Specification.new do |spec|
  spec.name          = "enum"
  spec.version       = Enum::VERSION
  spec.authors       = ["Andrey Koleshko"]
  spec.email         = ["ka8725@gmail.com"]

  spec.summary       = %q{Enum implementation}
  spec.description   = %q{This is a very basic implementation of enums in Ruby. The cornerstone of the library is safety.}
  spec.homepage      = "https://github.com/mezuka/enum"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "bundler", "~> 1.10"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "minitest"
  spec.add_development_dependency "i18n"
end
