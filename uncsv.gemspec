# frozen_string_literal: true

lib = File.expand_path('lib', __dir__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'uncsv/version'

Gem::Specification.new do |spec|
  spec.name = 'uncsv'
  spec.version = Uncsv::VERSION
  spec.authors = ['Justin Howard']
  spec.email = ['jmhoward0@gmail.com']
  spec.license = 'MIT'

  spec.summary = 'A parser for unruly CSVs'
  spec.homepage = 'https://github.com/nullscreen/uncsv'

  spec.files = `git ls-files -z`
    .split("\x0")
    .reject { |f| f.match(%r{^spec/}) }
  spec.require_paths = ['lib']

  spec.add_development_dependency 'bundler', '~> 1.12'
  spec.add_development_dependency 'fakefs', '~> 0.8'
  spec.add_development_dependency 'rake', '>= 10.0'
  spec.add_development_dependency 'redcarpet', '~> 3.4'
  spec.add_development_dependency 'rspec', '~> 3.4'
  spec.add_development_dependency 'rubocop', '~> 0.61'
  spec.add_development_dependency 'simplecov', '~> 0.11'
  spec.add_development_dependency 'yard', '>= 0.9.11'
end
