# frozen_string_literal: true

class Localization < ActiveRecord::Base
  belongs_to :localizable, polymorphic: true, optional: true, touch: true

  class << self
    def locales
      order("locale ASC").pluck(Arel.sql("DISTINCT locale"))
    end

    def names
      order("name ASC").pluck(Arel.sql("DISTINCT name"))
    end
  end

  def to_s
    value || ""
  end

  delegate :empty?, to: :to_s

  def translate(locale)
    localizable.localizations.find_by(name: name, locale: locale)
  end
end
