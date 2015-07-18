# -*- encoding: utf-8 -*-
$:.unshift File.expand_path('../lib', __FILE__)
require 'claide_completion/gem_version'

Gem::Specification.new do |s|
  s.name     = "claide-completion"
  s.version  = CLAideCompletion::VERSION
  s.license  = "MIT"
  s.email    = ["fabiopelosin@gmail.com"]
  s.homepage = "https://github.com/CocoaPods/claide-completion"
  s.authors  = ["Fabio Pelosin"]

  s.summary  = "CLI completion plugin for CLAide."

  s.files = Dir["lib/**/*.rb"] + %w{ README.markdown LICENSE }
  s.require_paths = %w{ lib }

  ## Make sure you can build the gem on older versions of RubyGems too:
  s.rubygems_version = "1.6.2"
  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.specification_version = 3 if s.respond_to? :specification_version
end
