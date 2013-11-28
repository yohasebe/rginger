#!/usr/bin/env ruby
# -*- coding: utf-8 -*-

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'rginger/version'

Gem::gemification.new do |gem|
  gem.name          = "rginger"
  gem.version       = RGinger::VERSION
  gem.authors       = ["Yoichiro Hasebe"]
  gem.email         = ["yohasebe@gmail.com"]
  gem.description   = "RGinger takes an English sentence and gives correction and rephrasing suggestions for it using Ginger proofreading API."
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/yohasebe/rginger"
  gem.license       = "MIT"

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}) { |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|gem|features)/})
  gem.require_paths = ["lib"]

  gem.add_development_dependency "bundler"
  gem.add_development_dependency "rake"
  gem.add_dependency "trollop"
  gem.add_dependency "rainbow"
end

