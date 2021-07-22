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
  s.licenses = ["MIT"]  # https://spdx.org/licenses/MIT-Modern-Variant.html
  s.rdoc_options = ["--line-numbers", "--title", s.summary, "--main", "README.md"]
  s.files = %w(
    README.md
    Rakefile
    attic.gemspec
    lib/attic.rb
  )
end
