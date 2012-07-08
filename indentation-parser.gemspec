# -*- encoding: utf-8 -*-
require File.expand_path('../lib/indentation-parser/version', __FILE__)

Gem::Specification.new do |gem|
  gem.authors       = ["Samuel Müller"]
  gem.email         = ["mueller.samu@gmail.com"]
  gem.description   = %q{indentation-parser}
  gem.summary       = %q{indentation-parser}
  gem.homepage      = ""

  gem.files         = `git ls-files`.split($\)
  gem.executables   = gem.files.grep(%r{^bin/}).map{ |f| File.basename(f) }
  gem.test_files    = gem.files.grep(%r{^(test|spec|features)/})
  gem.name          = "indentation-parser"
  gem.require_paths = ["lib"]
  gem.version       = Indentation::Parser::VERSION
  
  gem.add_development_dependency "rspec", "~> 2.11"
end
