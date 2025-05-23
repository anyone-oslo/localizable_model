# frozen_string_literal: true

module LocalizableModel
  # = LocalizableModel::InstanceMethods
  #
  # This is the public API for all localizable models.
  # See Localizable for usage examples.
  #
  module InstanceMethods
    # Returns all locales saved for this page.
    #
    delegate :locales, to: :localizer

    # Getter for locale
    #
    #  page.locale # => 'en'
    #
    delegate :locale, to: :localizer

    # Returns an AnyLocalizer for the model.
    #
    def any_localizer
      @any_localizer ||= AnyLocalizer.new(self)
    end
    alias any_locale any_localizer

    # Setter for locale
    #
    #  page.locale = 'no' # => 'no'
    #
    def locale=(locale)
      @localizer = Localizer.new(self)
      localizer.locale = locale
    end

    # Returns true if this page has a locale set
    #
    delegate :locale?, to: :localizer

    # Returns a copy of the model with a different locale.
    #
    #  localized = page.localize('en')
    #
    # localize also takes a block as an argument, which returns the
    # result of the block.
    #
    #  page.localize('nb') do |p|
    #    p.locale # => 'nb'
    #  end
    #  page.locale # => 'en'
    #
    def localize(locale)
      clone = self.clone.localize!(locale)
      block_given? ? (yield clone) : clone
    end

    # In-place variant of #localize.
    #
    #  page.localize!('en')
    #
    # This is functionally equivalent to setting locale=,
    # but returns the model instead of the locale and is chainable.
    #
    def localize!(locale)
      @localizer = Localizer.new(self)
      localizer.locale = locale
      self
    end

    # Returns a list of all the localized attributes
    #
    #  page.localized_attributes # => { "name" => { "en" => "Hello" } }
    #
    delegate :localized_attributes, to: :localizer

    # assign_attributes from ActiveRecord is overridden to catch locale before
    # any other attributes are written. This enables the following construct:
    #
    #  Page.create(name: 'My Page', locale: 'en')
    #
    def assign_attributes(new_attributes)
      if new_attributes.respond_to?(:[])
        attributes = new_attributes.stringify_keys
        self.locale = attributes["language"] if attributes.key?("language")
        self.locale = attributes["locale"]   if attributes.key?("locale")
      end
      super
    end

    # A localized model responds to :foo, :foo= and :foo?
    #
    def respond_to?(method_name, *args)
      requested_attribute, = method_name.to_s.match(/(.*?)([?=]?)$/)[1..2]
      localizer.attribute?(requested_attribute.to_sym) || super
    end

    alias translate localize
    alias translate! localize!
    alias working_language locale
    alias working_language= locale=

    protected

    # Getter for the model's Localizer.
    #
    def localizer
      @localizer ||= Localizer.new(self)
    end

    # Callback for cleaning up empty localizations.
    # This is performed automatically when the model is saved.
    #
    def cleanup_localizations!
      localizer.cleanup_localizations!
    end

    def respond_to_missing?(method_name, include_private = false)
      localizer.attribute?(method_to_attr(method_name)) || super
    end

    def method_missing(method_name, *args)
      attr = method_to_attr(method_name)
      return super unless localizer.attribute?(attr)

      case method_name.to_s
      when /\?$/
        localizer.value_for?(attr)
      when /=$/
        localizer.set(attr, args.first)
      else
        localizer.get(attr).to_s
      end
    end

    def method_to_attr(method_name)
      method_name.to_s.match(/(.*?)([?=]?)$/)[1].to_sym
    end
  end
end
