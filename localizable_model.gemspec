# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)
require "localizable_model/version"

Gem::Specification.new do |s|
  s.name        = "localizable_model"
  s.version     = LocalizableModel::VERSION
  s.authors     = ["Inge Jørgensen"]
  s.email       = ["inge@anyone.no"]
  s.homepage    = ""
  s.summary     = "Localization support for ActiveRecord objects"
  s.description = "LocalizableModel provides localization support for " \
                  "ActiveRecord objects"

  s.required_ruby_version = ">= 2.7.0"

  s.files = Dir[
    "{app,config,db,lib,vendor}/**/*",
    "Rakefile",
    "README.md"
  ]

  s.add_development_dependency "factory_bot"
  s.add_development_dependency "mysql2"
  s.add_development_dependency "pg"
  s.add_development_dependency "rspec-rails"
  s.add_development_dependency "shoulda-matchers"

  s.add_dependency "rails", "> 5.0"
end
