# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "carb/container/version"

Gem::Specification.new do |spec|
  spec.name          = "carb-container"
  spec.version       = Carb::Container::VERSION
  spec.authors       = ["Fire-Dragon-DoL"]
  spec.email         = ["francesco.belladonna@gmail.com"]

  spec.summary       = %q{Set of IoC containers for carb-inject}
  spec.description   = %q{Set of IoC containers for carb-inject}
  spec.homepage      = "https://github.com/Carburetor/carb-container"

  spec.files         = `git ls-files -z`.split("\x0").reject do |f|
    f.match(%r{^(test|spec|features)/})
  end
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "carb-core", ">= 1.0.0"

  spec.add_development_dependency "bundler", "~> 1.14"
  spec.add_development_dependency "rake",    "~> 11.0"
  spec.add_development_dependency "rspec",   "~> 3.0"
  spec.add_development_dependency "activesupport"
  spec.add_development_dependency "pry-byebug"
end
