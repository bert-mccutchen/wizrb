# frozen_string_literal: true

require_relative 'lib/wizrb/version'

Gem::Specification.new do |spec|
  spec.name          = 'wizrb'
  spec.version       = Wizrb::VERSION
  spec.authors       = ['Bert McCutchen']
  spec.email         = ['mail@bertm.dev']

  spec.summary       = 'State management for Philips WiZ devices.'
  spec.description   = 'Manage the state of your Philips WiZ devices.'
  spec.homepage      = 'https://github.com/bert-mccutchen/wizrb'
  spec.license       = 'MIT'
  spec.required_ruby_version = '>= 2.5.0'

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = 'https://github.com/bert-mccutchen/wizrb'
  spec.metadata['changelog_uri'] = 'https://github.com/bert-mccutchen/wizrb/blob/master/CHANGELOG.md'

  # Specify which files should be added to the gem when it is released.
  spec.files         = Dir['CHANGELOG.md', 'LICENSE.txt', 'README.md', 'doc/*', 'exe/*', 'lib/**/*']
  spec.bindir        = 'exe'
  spec.executables   = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ['lib']

  # Uncomment to register a new dependency of your gem
  # spec.add_dependency 'example-gem', '~> 1.0'
  spec.add_dependency 'thor', '~> 1.1'

  # For more information and examples about making a new gem, checkout our
  # guide at: https://bundler.io/guides/creating_gem.html
end
