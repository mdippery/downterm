lib = File.expand_path('../lib', __FILE__)
$LOAD_PATH.unshift(lib) unless $LOAD_PATH.include?(lib)
require 'downterm/version'

GEMSPEC = `git ls-files | grep gemspec`.chomp
GEM     = "downterm-#{Downterm::VERSION}.gem"

desc "Build downterm.gem"
task :build => :perms do
  system "gem", "build", GEMSPEC
end

desc "Ensure correct permissions for downterm.gem"
task :perms do
  system "chmod", "-R", "a+rX", *`git ls-files`.chomp.split("\n")
end

desc "Install downterm.gem"
task :install => :build do
  system "gem", "install", GEM
end

desc "Push gem to RubyGems"
task :release => :build do
  system "git", "tag", "-s", "-m", "downterm v#{Downterm::VERSION}", "v#{Downterm::VERSION}"
  system "gem", "push", GEM
end

desc "Clean built products"
task :clean do
  rm Dir.glob("*.gem"), :verbose => true
end

task :default => :build
