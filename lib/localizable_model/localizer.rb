# frozen_string_literal: true

module LocalizableModel
  class Localizer
    attr_accessor :locale

    def initialize(model)
      @model         = model
      @configuration = model.class.localizable_configuration
    end

    delegate :attribute?, to: :@configuration

    def locales
      @model.localizations.map(&:locale).uniq
    end

    def locale?
      locale ? true : false
    end

    def localized_attributes
      attribute_names.each_with_object({}) do |attr, h|
        h[attr] = {}
        locales.each { |l| h[attr][l] = get_value(attr, l) }
      end
    end

    def get(attribute, options = {})
      get_options = { locale: }.merge(options)
      find_localizations(
        attribute.to_s,
        get_options[:locale].to_s
      ).try(&:first) ||
        @model.localizations.new(
          locale: get_options[:locale].to_s,
          name: attribute.to_s
        )
    end

    def set(attribute, value, options = {})
      set_options = { locale: }.merge(options)
      if value.is_a?(Hash) || value.is_a?(ActionController::Parameters)
        value.each { |loc, val| set(attribute, val, locale: loc) }
      else
        require_locale!(attribute, set_options[:locale])
        get(attribute, locale: set_options[:locale]).value = value
      end
      value
    end

    def value_for?(attribute)
      get(attribute).value?
    end

    def cleanup_localizations!
      @model.localizations = @model.localizations.select(&:value?)
    end

    private

    def attribute_names
      @configuration.attributes.keys.map(&:to_s)
    end

    def find_localizations(name, locale)
      @model.localizations.select do |l|
        l.name == name && l.locale == locale
      end
    end

    def get_value(attribute, locale)
      localization = find_localizations(attribute, locale).try(&:first)
      localization&.value
    end

    def require_locale!(attribute, locale)
      return if locale

      raise(ArgumentError,
            "Tried to set :#{attribute}, but no locale has been set")
    end
  end
end
