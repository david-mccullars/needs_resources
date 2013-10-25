# -*- encoding: utf-8 -*-
require File.expand_path('../lib/needs_resources/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors = ["David McCullars"]
  gem.email = ["david.mccullars@gmail.com"]
  gem.description = %q{Ruby gem to provide lightweight inversion of control type resources for an application}
  gem.summary = %q{Ruby gem to provide lightweight inversion of control type resources for an application}
  gem.homepage = ""

  gem.files = `git ls-files`.split($\)
  gem.executables = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files = gem.files.grep(%r{^(test|spec|features)/})
  gem.name = "needs_resources"
  gem.require_paths = ["lib"]
  gem.version = NeedsResources::VERSION

  gem.add_dependency('active_support', '> 2.0')
end
