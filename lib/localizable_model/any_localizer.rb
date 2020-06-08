# frozen_string_literal: true

module LocalizableModel
  class AnyLocalizer
    attr_reader :record

    def initialize(record)
      @record = record
      define_localization_methods
    end

    private

    def define_localization_methods
      record.class.localized_attributes.each do |attribute|
        self.class.send(:define_method, attribute) do
          localized(attribute)
        end

        self.class.send(:define_method, "#{attribute}?") do
          localized?(attribute)
        end
      end
    end

    def locales
      (
        [record.locale, I18n.locale] + record.locales
      ).compact.map(&:to_sym).uniq
    end

    def localized?(attribute)
      !localized(attribute).blank?
    end

    def localized(attribute)
      localized = locales.inject(nil) do |str, l|
        str || lambda {
          value = record.localize(l).send(attribute)
          value.blank? ? nil : value
        }.call
      end
      localized || ""
    end
  end
end
