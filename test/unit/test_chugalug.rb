
require 'test/unit'
require 'chugalug'
require 'benchmark'

# Yeah, I know.
begin
  require 'csv'
  require 'rubygems'
  require 'fastercsv'
  require 'lightcsv'
  require 'csvscan'

  module CSVScan
    def self.foreach(file, &block)
      open(file) do |f|
        scan(f, &block)
      end
    end
  end
  
rescue LoadError
end

class TestCcsv < Test::Unit::TestCase
  
  def setup
    @dir = "#{File.dirname(__FILE__)}/../"
  end
  
  def test_should_raise
    assert_raises(RuntimeError) do
      Chugalug.foreach('fdssfd') do
      end
    end
  end
  
  def test_accuracy
    chugalug = []
    file = @dir + "data_small.csv"
    Chugalug.foreach(file) do |values|
      chugalug << values.dup
    end
    
    csv = []
    CSV.foreach(file) do |values|
      csv << values
    end  
     
    assert_equal csv, chugalug
  end
  
  def test_speed
    [Chugalug, FasterCSV, CSV].each do |klass| # CSVScan, LightCsv, 
      Benchmark.bm do |x|
        x.report(klass.name) do 
          klass.foreach(@dir + "data.csv") do |values| end
        end
      end
    end
  end
  
  def test_quoted_values
    # file = @dir + "quoted_values.csv"
    # Chugalug.foreach(file) do |values|
    #   # puts values.inspect
    # end
  end
end
