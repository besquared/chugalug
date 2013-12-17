require 'rubygems'
require 'bundler/setup'

# SimpleCov.start do
#   add_filter "/spec"
# end

require 'tmpdir'

require 'csv'
require 'benchmark'

RSpec.configure do |config|
  config.filter_run_excluding :benchmark => true

  def data_path(file)
    File.join(File.dirname(__FILE__), 'data', file)
  end
end