# coding: utf-8
lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)

require 'puma/hunter/version'

Gem::Specification.new do |spec|
  spec.name          = "puma-hunter"
  spec.version       = Puma::Hunter::VERSION
  spec.authors       = ["Anton Semenov"]
  spec.email         = ["anton.estum@gmail.com"]

  spec.summary       = %q{Task to kill Puma web server workers.}
  spec.description   = %q{Like the puma_worker_killer, but designed to run separately from a cron job.}
  spec.homepage      = "https://github.com/estum/puma-hunter"
  spec.license       = "MIT"

  spec.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  spec.bindir        = "exe"
  spec.executables   = spec.files.grep(%r{^exe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  spec.add_dependency "procps-rb"
  spec.add_runtime_dependency "methadone"

  spec.add_development_dependency "bundler", "~> 1.11"
  spec.add_development_dependency "rake", "~> 10.0"
end
