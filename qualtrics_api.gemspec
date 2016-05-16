# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

# Maintain your gem's version:
require "qualtrics_api/version"

# Describe your gem and declare its dependencies:
Gem::Specification.new do |s|
  s.name        = "qualtrics_api"
  s.version     = QualtricsApi::VERSION
  s.authors     = ["Damian Galindo Meza"]
  s.email       = ["demian007@gmail.com"]
  s.homepage    = ""
  s.summary     = "Client for Qualtrics API V3"
  s.description = "Client for Qualtrics API V3 with Faraday"
  s.license     = "MIT"

  s.files         = `git ls-files -z`.split("\x0")
  s.executables   = s.files.grep(%r{^bin/}) { |f| File.basename(f) }
  s.test_files    = s.files.grep(%r{^(test|spec|features)/})
  s.require_paths = ['lib']

  s.add_runtime_dependency 'configatron'
  s.add_runtime_dependency 'faraday'
  s.add_runtime_dependency 'faraday_middleware'
  s.add_runtime_dependency 'activemodel', '~> 4'
  s.add_runtime_dependency 'activesupport', '~> 4.2', '>= 4.2.0'
  s.add_runtime_dependency 'nokogiri'
  s.add_runtime_dependency 'rubyzip'

  s.add_development_dependency 'bundler', '~> 1.6'
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'dotenv'
  s.add_development_dependency 'vcr'
  s.add_development_dependency 'webmock'
  s.add_development_dependency 'coveralls'
end

