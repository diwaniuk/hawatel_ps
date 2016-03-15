require "bundler/gem_tasks"
require "rspec/core/rake_task"

platform = 'windows' if RUBY_PLATFORM =~ /mswin|msys|mingw|cygwin|bccwin|wince|emc/
platform = 'linux'  if RUBY_PLATFORM =~ /linux/

RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern    = FileList["spec/#{platform}/*/*_spec.rb"]
  spec.rspec_opts = ['--color', '--format d']
end

task :default => :spec
