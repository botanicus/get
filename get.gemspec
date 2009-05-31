# coding: utf-8

begin
  require "rubygems/specification"
rescue SecurityError
  # http://gems.github.com
end

VERSION  = "0.0.1"
SPECIFICATION = ::Gem::Specification.new do |s|
  s.name = "get"
  s.version = VERSION
  s.authors = ["Jakub Šťastný aka Botanicus"]
  s.homepage = "http://github.com/botanicus/get"
  s.summary = "Get is CLI download manager for automatic downloading the whole files of specified type from given web."
  s.description = "" # TODO: long description
  s.cert_chain = nil
  s.email = ["knava.bestvinensis", "gmail.com"].join("@")
  s.files = Dir.glob("**/*") - Dir.glob("pkg/*")
  s.executables = ["get.rb"]
  s.default_executable = "get.rb"
  # s.add_dependency "xmpp4r"
  s.require_paths = ["lib"]
  # s.required_ruby_version = ::Gem::Requirement.new(">= 1.9.1")
  # s.rubyforge_project = "get"
end
