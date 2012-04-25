# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = "chugalug"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 1.2") if s.respond_to? :required_rubygems_version=
  s.authors = ["Josh Ferguson"]
  s.date = "2012-04-25"
  s.description = "A wrapper around libcsv."
  s.email = "josh@besquared.net"
  s.extensions = ["ext/extconf.rb"]
  s.extra_rdoc_files = ["CHANGELOG", "LICENSE", "README", "ext/chugalug.c", "ext/csv.h", "ext/extconf.rb", "ext/libcsv.c"]
  s.files = ["CHANGELOG", "LICENSE", "Manifest", "README", "Rakefile", "ext/chugalug.c", "ext/csv.h", "ext/extconf.rb", "ext/libcsv.c", "test/data.csv", "test/data_small.csv", "test/easy.csv", "test/messages.csv", "test/quoted_values.csv", "test/unit/test_chugalug.rb", "chugalug.gemspec"]
  s.homepage = "http://www.github.com/besquared/chugalug/"
  s.rdoc_options = ["--line-numbers", "--inline-source", "--title", "Chugalug", "--main", "README"]
  s.require_paths = ["lib", "ext"]
  s.rubyforge_project = "Besquared"
  s.rubygems_version = "1.8.15"
  s.summary = "A wrapper around libcsv."
  s.test_files = ["test/unit/test_chugalug.rb"]

  if s.respond_to? :specification_version then
    s.specification_version = 3

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
    else
    end
  else
  end
end
