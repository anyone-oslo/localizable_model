# frozen_string_literal: true

FactoryBot.define do
  factory :localization do
    name { "name" }
    locale { "nb" }
    localizable factory: %i[blank_page]
  end
end
