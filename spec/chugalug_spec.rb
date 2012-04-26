require 'csv'
require 'fastercsv'
require 'lib/chugalug'
require 'benchmark'

def file_path(name)
  File.join(File.dirname(__FILE__), 'data', "#{name}.csv")
end

RSpec.configure do |c|
  # declare an exclusion filter
  c.filter_run_excluding :benchmark => true
end

describe "A chugalug" do
  it "should raise if a file is not given" do
    lambda {
      Chugalug.foreach('fdssfd') do
      end
    }.should raise_error(RuntimeError)
  end
  
  it "should parse the correct number of lines" do
    chugalug = []
    Chugalug.foreach(file_path('data_small')) do |values|
      chugalug << values.dup
    end
    
    csv = []
    CSV.foreach(file_path('data_small')) do |values|
      csv << values
    end
    
    chugalug.should == csv
  end
  
  it "should parse files with non-standard field delimiters" do
    chugalug = []
    Chugalug.foreach(file_path('pipe_delim'), {:col_sep => '|'}) do |values|
      chugalug << values.dup
    end
    
    chugalug.each do |row|
      row.length.should == 12
    end
    chugalug.length.should == File.readlines(file_path('pipe_delim')).length
  end
  
  it "should benchmark", :benchmark => true do
    [Chugalug, FasterCSV, CSV].each do |klass|
      Benchmark.bm do |x|
        x.report(klass.name) do 
          klass.foreach(file_path('data')) do |values| end
        end
      end
    end
  end
end