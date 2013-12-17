require "bundler/gem_tasks"
require "rake/extensiontask"
require "rspec/core/rake_task"

Rake::ExtensionTask.new('chugalug') do |ext|
  ext.lib_dir = 'lib/chugalug'
end

RSpec::Core::RakeTask.new(:spec)

desc "Recompile native code"
task :recompile => [:clobber, :compile] # clean build

task :default => [:recompile, :spec]