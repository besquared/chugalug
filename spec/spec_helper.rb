require 'rubygems'
require 'bundler/setup'

require 'simplecov'

SimpleCov.start do
  add_filter "/spec"
end

require 'chugalug'

RSpec.configure do |config|
  config.filter_run_excluding :benchmark => true

  def data_path(file)
    File.join(File.dirname(__FILE__), 'data', file)
  end
end