# -*- encoding: utf-8 -*-
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'downterm/version'

Gem::Specification.new do |gem|
  gem.name          = 'downterm'
  gem.version       = Downterm::VERSION
  gem.licenses      = ['MIT']
  gem.authors       = ['Michael Dippery']
  gem.email         = ['michael@monkey-robot.com']
  gem.homepage      = 'https://github.com/mdippery/downterm'
  gem.description   = 'Converts Markdown into text suitable for output to a terminal'
  gem.summary       = 'Converts Markdown into text suitable for output to a terminal'

  gem.files         = `git ls-files`.split($/)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.require_paths = ["lib"]

  gem.add_runtime_dependency('highline', '~> 1.7')
  gem.add_runtime_dependency('rainbow', '~> 2.0')
  gem.add_runtime_dependency('redcarpet', '~> 3.3')

  gem.add_development_dependency('rspec', '~> 3.3')
end
