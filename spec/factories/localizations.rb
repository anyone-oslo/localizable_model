# frozen_string_literal: true

FactoryBot.define do
  factory :localization do
    name { "name" }
    locale { "nb" }
    association :localizable, factory: :blank_page
  end
end
