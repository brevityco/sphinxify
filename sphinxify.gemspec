# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: sphinxify 0.0.1 ruby lib

Gem::Specification.new do |s|
  s.name = "sphinxify"
  s.version = "0.0.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["Richard Bliss"]
  s.date = "2014-03-04"
  s.description = ""
  s.email = "richard@brevity.us"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".ruby-gemset",
    ".ruby-version",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "lib/sphinxify.rb",
    "lib/sphinxify/builder.rb",
    "lib/sphinxify/options.rb",
    "spec/builder_spec.rb",
    "spec/options_spec.rb",
    "spec/spec_helper.rb",
    "sphinxify.gemspec"
  ]
  s.homepage = "http://github.com/brevityco/sphinxify"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.2.2"
  s.summary = "Sphinxify maps request params into a suitable Thinking Sphinx query hash for filtering, sorting, and field weighting."

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<activesupport>, [">= 3.2.0"])
      s.add_development_dependency(%q<bundler>, [">= 0"])
      s.add_development_dependency(%q<byebug>, [">= 0"])
      s.add_development_dependency(%q<jeweler>, [">= 0"])
      s.add_development_dependency(%q<rspec>, [">= 0"])
    else
      s.add_dependency(%q<activesupport>, [">= 3.2.0"])
      s.add_dependency(%q<bundler>, [">= 0"])
      s.add_dependency(%q<byebug>, [">= 0"])
      s.add_dependency(%q<jeweler>, [">= 0"])
      s.add_dependency(%q<rspec>, [">= 0"])
    end
  else
    s.add_dependency(%q<activesupport>, [">= 3.2.0"])
    s.add_dependency(%q<bundler>, [">= 0"])
    s.add_dependency(%q<byebug>, [">= 0"])
    s.add_dependency(%q<jeweler>, [">= 0"])
    s.add_dependency(%q<rspec>, [">= 0"])
  end
end

