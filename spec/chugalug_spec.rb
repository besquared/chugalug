require 'spec_helper'

describe Chugalug do
  it "should raise if a file is not given" do
    lambda {
      Chugalug::Parser.foreach('fdssfd') do
      end
    }.should raise_error(RuntimeError)
  end
  
  it "should parse the correct number of lines" do
    chugalug = []
    Chugalug::Parser.foreach(data_path('data_small.csv')) do |values|
      puts values.inspect

      chugalug << values.dup
    end
  end
  
  it "should parse files with non-standard field delimiters" do
    chugalug = []
    Chugalug::Parser.foreach(data_path('pipe_delim.csv'), {:col_sep => '|'}) do |values|
      chugalug << values.dup
    end
    
    chugalug.each do |row|
      row.length.should == 12
    end
    chugalug.length.should == File.readlines(data_path('pipe_delim.csv')).length
  end
  
  it "should parse files with non-standard row delimiters" do
    chugalug = []
    Chugalug::Parser.foreach(data_path('term_delim.csv'), {:col_sep => '|', :row_sep => '*'}) do |values|
      chugalug << values.dup
    end
        
    chugalug.each do |row|
      row.length.should == 12
    end
    chugalug.length.should == File.readlines(data_path('pipe_delim.csv')).length
  end
end