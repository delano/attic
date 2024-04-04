require 'rubygems'
require 'rake/clean'
require 'rubygems/package_task'
require 'fileutils'
require 'rdoc/task'
include FileUtils

task :default => :package

# CONFIG =============================================================

# Change the following according to your needs
README = "README.md"

# Files and directories to be deleted when you run "rake clean"
CLEAN.include [ 'pkg', '*.gem', '.config']

# Virginia assumes your project and gemspec have the same name
name = 'attic'
load "#{name}.gemspec"
version = @spec.version

# That's it! The following defaults should allow you to get started
# on other things.


# TESTS/SPECS =========================================================



# INSTALL =============================================================

Gem::PackageTask.new(@spec) do |p|
  p.need_tar = true if RUBY_PLATFORM !~ /mswin/
end

task :release => [ :rdoc, :package ]
task :install => [ :rdoc, :package ] do
	sh %{sudo gem install pkg/#{name}-#{version}.gem}
end
task :uninstall => [ :clean ] do
	sh %{sudo gem uninstall #{name}}
end


# RUBY DOCS TASK ==================================

Rake::RDocTask.new do |t|
	t.rdoc_dir = 'doc'
	t.title    = @spec.summary
	t.options << '--line-numbers' << '-A cattr_accessor=object'
	t.options << '--charset' << 'utf-8'
	t.rdoc_files.include(README)
	t.rdoc_files.include('lib/**/*.rb')
end


