# encoding: utf-8

FactoryBot.define do
  factory :localization do
    name { "name" }
    locale { "nb" }
    association :localizable, factory: :blank_page
  end
end
