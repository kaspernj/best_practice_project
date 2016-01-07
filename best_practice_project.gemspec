# Generated by jeweler
# DO NOT EDIT THIS FILE DIRECTLY
# Instead, edit Jeweler::Tasks in Rakefile, and run 'rake gemspec'
# -*- encoding: utf-8 -*-
# stub: best_practice_project 0.0.8 ruby lib

Gem::Specification.new do |s|
  s.name = "best_practice_project"
  s.version = "0.0.8"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.require_paths = ["lib"]
  s.authors = ["kaspernj"]
  s.date = "2016-01-07"
  s.description = "A bundle of various linters and code inspection tools"
  s.email = "k@spernj.org"
  s.extra_rdoc_files = [
    "LICENSE.txt",
    "README.md"
  ]
  s.files = [
    ".document",
    ".rspec",
    ".rubocop.yml",
    "Gemfile",
    "Gemfile.lock",
    "LICENSE.txt",
    "README.md",
    "Rakefile",
    "VERSION",
    "best_practice_project.gemspec",
    "lib/best_practice_project.rb",
    "lib/best_practice_project/base_handler.rb",
    "lib/best_practice_project/coffee_lint_handler.rb",
    "lib/best_practice_project/config/haml-lint.yml",
    "lib/best_practice_project/config/rubocop.yml",
    "lib/best_practice_project/haml_lint_handler.rb",
    "lib/best_practice_project/rails_best_practices_handler.rb",
    "lib/best_practice_project/rubocop_handler.rb",
    "lib/best_practice_project/scss_lint_handler.rb",
    "lib/tasks/best_practice_project.rake",
    "shippable.yml",
    "spec/best_practice_project_spec.rb",
    "spec/spec_helper.rb"
  ]
  s.homepage = "http://github.com/kaspernj/best_practice_project"
  s.licenses = ["MIT"]
  s.rubygems_version = "2.4.0"
  s.summary = "A bundle of various linters and code inspection tools"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<auto_autoloader>, [">= 0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_development_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_development_dependency(%q<bundler>, ["~> 1.0"])
      s.add_development_dependency(%q<jeweler>, ["~> 2.0.1"])
      s.add_development_dependency(%q<simplecov>, [">= 0"])
    else
      s.add_dependency(%q<auto_autoloader>, [">= 0"])
      s.add_dependency(%q<rspec>, ["~> 2.8.0"])
      s.add_dependency(%q<rdoc>, ["~> 3.12"])
      s.add_dependency(%q<bundler>, ["~> 1.0"])
      s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
      s.add_dependency(%q<simplecov>, [">= 0"])
    end
  else
    s.add_dependency(%q<auto_autoloader>, [">= 0"])
    s.add_dependency(%q<rspec>, ["~> 2.8.0"])
    s.add_dependency(%q<rdoc>, ["~> 3.12"])
    s.add_dependency(%q<bundler>, ["~> 1.0"])
    s.add_dependency(%q<jeweler>, ["~> 2.0.1"])
    s.add_dependency(%q<simplecov>, [">= 0"])
  end
end

