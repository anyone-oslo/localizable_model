# frozen_string_literal: true

$LOAD_PATH.push File.expand_path("lib", __dir__)
require "localizable_model/version"

Gem::Specification.new do |s|
  s.name        = "localizable_model"
  s.version     = LocalizableModel::VERSION
  s.authors     = ["Inge Jørgensen"]
  s.email       = ["inge@anyone.no"]
  s.homepage    = "https://github.com/anyone-oslo/localizable_model"
  s.license     = "MIT"
  s.summary     = "Localization support for ActiveRecord objects"
  s.description = "LocalizableModel provides localization support for " \
                  "ActiveRecord objects"

  s.required_ruby_version = ">= 3.1.0"

  s.files = Dir[
    "{app,config,db,lib,vendor}/**/*",
    "Rakefile",
    "README.md"
  ]

  s.add_dependency "rails", "> 5.0"
  s.metadata = {
    "bug_tracker_uri" => "https://github.com/anyone-oslo/localizable_model/issues",
    "changelog_uri" => "https://github.com/anyone-oslo/localizable_model/blob/main/CHANGELOG.md",
    "documentation_uri" => "https://www.rubydoc.info/gems/localizable_model",
    "rubygems_mfa_required" => "true",
    "source_code_uri" => "https://github.com/anyone-oslo/localizable_model"
  }
end
