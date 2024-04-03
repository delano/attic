Gem::Specification.new do |s|
  s.name        = "attic"
  s.version     = "0.9.0.rc1"
  s.summary     = "When in doubt, store it in the attic"
  s.description = "Attic: a place to hide metadata about the class or variable itself (e.g. SHA hash summaries)."
  s.authors     = ["Delano Mandelbaum"]
  s.email       = "gems@solutious.com"
  s.homepage    = "https://github.com/delano/attic"
  s.license     = "MIT"

  s.files         = `git ls-files -z`.split("\x0").reject { |f| f.match(%r{^(test|spec|features)/}) }
  s.bindir        = "exe"
  s.executables   = s.files.grep(%r{^exe/}) { |f| File.basename(f) }
  s.require_paths = ["lib"]

  s.required_ruby_version = Gem::Requirement.new(">= 2.6.0")

  s.add_dependency "rake", ">= 13.0.6"

  # Add development dependencies
  s.add_development_dependency "rspec", "~> 3.0"
  s.add_development_dependency "rubocop", "~> 1.0"
end
