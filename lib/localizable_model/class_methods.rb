# frozen_string_literal: true

module LocalizableModel
  # = LocalizableModel::ClassMethods
  #
  # Class methods for all Localizable models.
  #
  module ClassMethods
    # Returns a scope where all records will be set to the given locale.
    #
    def in_locale(locale)
      all
        .extending(LocalizableModel::ScopeExtension)
        .localize(locale)
        .includes(:localizations)
    end

    # Returns a scope with only records matching the given locale.
    #
    #  Page.localized('en').first.locale # => 'en'
    #
    def localized(locale)
      in_locale(locale)
        .where(localizations: { locale: })
        .references(:localizations)
    end

    def localized_attributes
      localizable_configuration.attributes.keys
    end

    # Accessor for the configuration.
    def localizable_configuration
      @localizable_configuration ||= inherited_localizable_configuration
    end

    private

    def define_localizable_methods!
      localizable_configuration.attributes.each_key do |name|
        define_method(name)       { localizer.get(name).to_s }
        define_method("#{name}?") { localizer.value_for?(name) }
        define_method("#{name}=") { |value| localizer.set(name, value) }
      end
    end

    def inherited_localizable_configuration
      if superclass.respond_to?(:localizable_configuration)
        LocalizableModel::Configuration.new(
          superclass.localizable_configuration.attributes.dup
        )
      else
        LocalizableModel::Configuration.new
      end
    end
  end
end
