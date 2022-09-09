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

  rubydoc = 'https://www.rubydoc.info/gems'
  spec.metadata = {
    'changelog_uri' => "#{spec.homepage}/blob/main/CHANGELOG.md",
    'documentation_uri' => "#{rubydoc}/#{spec.name}/#{spec.version}",
    'rubygems_mfa_required' => 'true'
  }

  spec.files = Dir['lib/**/*.rb', '*.md', '*.txt', '.yardopts']
  spec.require_paths = ['lib']

  spec.required_ruby_version = '>= 2.3'

  spec.add_development_dependency 'fakefs', '~> 1.2'
  spec.add_development_dependency 'rspec', '~> 3.10'
end
