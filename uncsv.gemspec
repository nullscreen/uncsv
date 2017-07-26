# coding: utf-8

lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'uncsv/version'

Gem::Specification.new do |spec|
  spec.name = 'uncsv'
  spec.version = Uncsv::VERSION
  spec.authors = ['Justin Howard']
  spec.email = ['jmhoward0@gmail.com']
  spec.license = 'Apache-2.0'

  spec.summary = 'A parser for unruly CSVs'
  spec.homepage = 'https://bitbucket.com/machinima-dev/uncsv'

  spec.files = `git ls-files -z`
    .split("\x0")
    .reject { |f| f.match(%r{^spec/}) }
  spec.bindir = 'exe'
  spec.executables = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'rake', '~> 10.0'
  spec.add_development_dependency 'rubocop', '~> 0.40'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'yard', '~> 0.8'
  spec.add_development_dependency 'fakefs', '~> 0.8'
  spec.add_development_dependency 'simplecov', '~> 0.11'
end
