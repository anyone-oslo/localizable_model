# frozen_string_literal: true

module LocalizableModel
  class AnyLocalizer
    attr_reader :record

    def initialize(record)
      @record = record
      @attributes = record.class.localized_attributes.to_set
    end

    def respond_to_missing?(method_name, include_private = false)
      attr = method_name.to_s.delete_suffix("?")
      @attributes.include?(attr.to_sym) || super
    end

    def method_missing(method_name, *args)
      name = method_name.to_s
      if name.end_with?("?")
        attr = name.delete_suffix("?").to_sym
        return super unless @attributes.include?(attr)

        localized?(attr)
      else
        return super unless @attributes.include?(method_name)

        localized(method_name)
      end
    end

    private

    def locales
      (
        [record.locale, I18n.locale] + record.locales
      ).compact.map(&:to_sym).uniq
    end

    def localized?(attribute)
      localized(attribute).present?
    end

    def localized(attribute)
      locales.each do |l|
        value = record.localize(l).send(attribute)
        return value if value.present?
      end
      ""
    end
  end
end
