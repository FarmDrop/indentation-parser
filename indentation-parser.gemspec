# -*- encoding: utf-8 -*-
require File.expand_path('../lib/indentation-parser/version', __FILE__)

Gem::Specification.new do |gem|
  gem.name          = "indentation-parser"
  gem.version       = Indentation::Parser::VERSION
  
  gem.authors       = ["Samuel Müller"]
  gem.email         = ["mueller.samu@gmail.com"]
  gem.description   = %q{Parses source code that defines context by indentation.}
  gem.summary       = gem.description
  gem.homepage      = "https://github.com/ssmm/indentation-parser"

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})  
  gem.require_paths = ["lib"]
  
  gem.add_development_dependency "rspec", "~> 2.11"
end
