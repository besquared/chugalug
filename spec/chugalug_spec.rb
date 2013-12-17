require 'spec_helper'

describe Chugalug do
  it "should raise if a file is not given" do
    lambda {
      Chugalug::Parser.foreach('fdssfd') do
      end
    }.should raise_error(RuntimeError)
  end

  describe "Parsing" do
    it "With default field delimiters" do
      row_count = 0
      Chugalug::Parser.foreach(data_path('data_small.csv')) do |row|
        row_count += 1
      end
      row_count.should == 20
    end
    
    it "With non-standard field delimiters" do
      row_count = 0
      Chugalug::Parser.foreach(data_path('pipe_delim.csv'), {:col_sep => '|'}) do |values|
        row_count += 1
      end
      row_count.should == 10
    end
    
    it "With non-standard row delimiters" do
      row_count = 0
      Chugalug::Parser.foreach(data_path('term_delim.csv'), {:col_sep => '|', :row_sep => '*'}) do |values|
        row_count += 1
      end
      row_count.should == 10
    end

    it "With a different encoding" do
      Chugalug::Parser.foreach(data_path('data_small.csv'), :encoding => 'UTF-8') do |values|
        values.each do |value|
          value.encoding.name.should == 'UTF-8'
        end
      end
    end
  end
end