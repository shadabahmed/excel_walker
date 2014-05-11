# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'excel_walker/version'

Gem::Specification.new do |spec|
  spec.name          = 'excel_walker'
  spec.version       = ExcelWalker::VERSION
  spec.authors       = ['Shadab Ahmed']
  spec.email         = ['shadab.ansari@gmail.com']
  spec.description   = %q{A declarative parser and builder for Excel Files}
  spec.summary       = %q{This gem chooses a different approach to Excel Parsing since excel can contain many regions of interest.}
  spec.homepage      = 'https://github.com/shadabahmed/excel_walker'
  spec.license       = 'MIT'

  spec.files         = `git ls-files`.split($/)
  spec.executables   = spec.files.grep(%r{^bin/}) { |f| File.basename(f) }
  spec.test_files    = spec.files.grep(%r{^(test|spec|features)/})
  spec.require_paths = ['lib']

  spec.add_dependency 'creek', '~>1.0.4'
  spec.add_dependency 'axlsx', '~>2.0.1'
  spec.add_dependency 'activesupport', '> 3.0.0'
  spec.add_development_dependency 'bundler', '~> 1.3'
  spec.add_development_dependency 'rake'
end
