require 'echoe'
require 'rake'
require 'rspec/core/rake_task'

Echoe.new("chugalug") do |p|
  p.author = "Josh Ferguson"
  p.email = "josh@besquared.net"
  p.project = "Besquared"
  p.summary = "A wrapper around libcsv."
  p.url = "http://www.github.com/besquared/chugalug/"
end

RSpec::Core::RakeTask.new(:spec) do |t|
  t.pattern = 'spec/**/*_spec.rb'
  t.rspec_opts = ['--options', "\"spec/spec.opts\""]
end