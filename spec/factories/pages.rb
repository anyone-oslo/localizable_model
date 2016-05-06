# encoding: utf-8

FactoryGirl.define do
  factory :page do
    locale I18n.default_locale
    sequence(:name) { |n| "Page #{n}" }

    factory :blank_page do
      name nil
    end
  end
end
