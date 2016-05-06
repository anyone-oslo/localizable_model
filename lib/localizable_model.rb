# encoding: utf-8

load "localizable_model/active_record_extension.rb"
load "localizable_model/class_methods.rb"
load "localizable_model/configuration.rb"
load "localizable_model/engine.rb"
load "localizable_model/instance_methods.rb"
load "localizable_model/localizer.rb"
load "localizable_model/scope_extension.rb"
load "localizable_model/version.rb"

# = Localizable
#
# Localizable allows any model to have localized attributes.
#
# == Configuring the model
#
#  class Page < ActiveRecord::Base
#    localizable do
#      attribute :name
#      attribute :body
#    end
#  end
#
# == Usage
#
#  page = Page.create(name: 'Hello', locale: 'en')
#  page.name?     # => true
#  page.name.to_s # => 'Hello'
#
# The localized attributes always return an instance of Localization.
#
# To get a localized version of a page, call .localize on it:
#
#  page = Page.first.localize('en')
#
# .localize also takes a block argument:
#
#  page.localize('nb') do |p|
#    p.locale # => 'nb'
#  end
#  page.locale # => 'en'
#
# Multiple locales can be updated at the same time:
#
#  page.name = {'en' => 'Hello', 'nb' => 'Hallo'}
#
module LocalizableModel
end
