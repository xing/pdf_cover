# coding: utf-8
lib = File.expand_path("../lib", __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require "pdf_cover/version"

Gem::Specification.new do |spec|
  spec.name          = "pdf_cover"
  spec.version       = PdfCover::VERSION
  spec.authors       = ["Juan González"]
  spec.email         = ["juan.gonzalez@xing.com"]

  spec.summary       = %(Convert first page of a PDF into an image format on Carrierwave and Paperclip )
  spec.description   = %(Provides processors for both Carrierwave and Paperclip to allow
                         having a version of a PDF attachment that is actually an image
                         representing the first page on that PDF. This gem uses GhostScript,
                         so it must be installed in order for it to work.)
  spec.homepage      = "http://githum.com/xing/pdf_cover"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_development_dependency "activesupport", ">= 4.2", "< 6.0.0"

  spec.add_development_dependency "appraisal"

  spec.add_development_dependency "awesome_print"
  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
  spec.add_development_dependency "simplecov"
  spec.add_development_dependency "rspec", "~> 3.0"
  spec.add_development_dependency "rubocop", "~> 0.37.2"
  spec.add_development_dependency "sqlite3", "~> 1.3.6"

  spec.add_development_dependency "byebug"
  spec.add_development_dependency "fivemat"
  spec.add_development_dependency "coveralls"

  spec.add_development_dependency "paperclip", "=4.1.1"
  spec.add_development_dependency "carrierwave", "~> 0.10"

  spec.add_development_dependency "rmagick", "~> 2.13.2"

  spec.add_runtime_dependency "rails", ">= 4.2"
end
