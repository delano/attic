@spec = Gem::Specification.new do |s|
	s.name = "attic"
	s.version = "0.6-RC1"
	s.summary = "When in doubt, store it in the attic"
	s.description = "Attic: a place to hide metadata about the class or variable itself (e.g. SHA hash summaries)."
	s.author = "Delano Mandelbaum"
	s.email = "gems@solutious.com"
	s.homepage = "http://github.com/delano/attic"
  s.executables = %w[]
  s.require_paths = %w[lib]
  s.extra_rdoc_files = %w[README.md]
  s.rdoc_options = ["--line-numbers", "--title", s.summary, "--main", "README.md"]
  s.files = %w(
    CHANGES.txt
    LICENSE.txt
    README.rdoc
    Rakefile
    attic.gemspec
    lib/attic.rb
    try/01_mixins_tryouts.rb
    try/10_attic_tryouts.rb
    try/20_accessing_tryouts.rb
    try/25_string_tryouts.rb
    try/30_nometaclass_tryouts.rb
    try/40_explicit_accessor_tryouts.rb
    try/X1_metaclasses.rb
    try/X2_extending.rb
  )
end
