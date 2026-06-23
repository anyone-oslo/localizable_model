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
      @model.localizations.map(&:locale).compact_blank.uniq
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

    def save_localizations!
      records    = @model.localizations.target
      removable  = records.select { |l| l.persisted? && !l.value? }
      upsertable = records.select { |l| upsertable?(l) }

      unless removable.empty? && upsertable.empty?
        delete_localizations(removable)
        upsert_localizations(upsertable)
        touch_localizable
      end

      @model.association(:localizations).reset
    end

    private

    def upsertable?(localization)
      localization.value? &&
        (localization.new_record? || localization.value_changed?)
    end

    def delete_localizations(records)
      ids = records.map(&:id)
      Localization.where(id: ids).delete_all if ids.any?
    end

    def upsert_localizations(records)
      return if records.empty?

      Localization.upsert_all( # rubocop:disable Rails/SkipsModelValidations
        records.map { |l| localization_row(l) },
        unique_by: %i[localizable_id localizable_type name locale]
      )
    end

    def localization_row(localization)
      { localizable_id: @model.id,
        localizable_type: @model.class.polymorphic_name,
        name: localization.name,
        locale: localization.locale,
        value: localization.value }
    end

    def touch_localizable
      return if @model.previously_new_record?
      return if @model.saved_changes.except("created_at", "updated_at").any?

      @model.touch # rubocop:disable Rails/SkipsModelValidations
    end

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
