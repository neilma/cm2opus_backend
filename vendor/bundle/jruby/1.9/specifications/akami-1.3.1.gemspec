# -*- encoding: utf-8 -*-
# stub: akami 1.3.1 ruby lib

Gem::Specification.new do |s|
  s.name = "akami"
  s.version = "1.3.1"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Daniel Harrington"]
  s.date = "2015-05-24"
  s.description = "Building Web Service Security"
  s.email = ["me@rubiii.com"]
  s.homepage = "https://github.com/savonrb/akami"
  s.licenses = ["MIT"]
  s.require_paths = ["lib"]
  s.required_ruby_version = Gem::Requirement.new(">= 1.9.2")
  s.rubyforge_project = "akami"
  s.rubygems_version = "2.1.9"
  s.summary = "Web Service Security"

  if s.respond_to? :specification_version then
    s.specification_version = 4

    if Gem::Version.new(Gem::VERSION) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<gyoku>, [">= 0.4.0"])
      s.add_runtime_dependency(%q<nokogiri>, [">= 0"])
      s.add_development_dependency(%q<rake>, ["~> 10.0"])
      s.add_development_dependency(%q<rspec>, ["~> 2.14"])
      s.add_development_dependency(%q<timecop>, ["~> 0.5"])
    else
      s.add_dependency(%q<gyoku>, [">= 0.4.0"])
      s.add_dependency(%q<nokogiri>, [">= 0"])
      s.add_dependency(%q<rake>, ["~> 10.0"])
      s.add_dependency(%q<rspec>, ["~> 2.14"])
      s.add_dependency(%q<timecop>, ["~> 0.5"])
    end
  else
    s.add_dependency(%q<gyoku>, [">= 0.4.0"])
    s.add_dependency(%q<nokogiri>, [">= 0"])
    s.add_dependency(%q<rake>, ["~> 10.0"])
    s.add_dependency(%q<rspec>, ["~> 2.14"])
    s.add_dependency(%q<timecop>, ["~> 0.5"])
  end
end
