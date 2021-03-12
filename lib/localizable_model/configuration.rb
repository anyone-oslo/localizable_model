# frozen_string_literal: true

module LocalizableModel
  class Configuration
    def initialize(attributes = nil)
      @attribute_table = attributes
    end

    def attribute(attribute_name, options = {})
      attribute_table[attribute_name.to_sym] = options
    end

    def attributes
      attribute_table.merge(dictionary_attributes)
    end

    def dictionary(dict)
      dictionaries << dict
    end

    def attribute?(attribute)
      attributes.keys.include?(attribute)
    end

    private

    def dictionaries
      @dictionaries ||= []
    end

    def dictionary_attributes
      dictionaries.map(&:call).inject({}) do |attrs, list|
        attrs.merge(hashify(list))
      end
    end

    def hashify(list)
      return list if list.is_a?(Hash)

      list.index_with do |_e|
        {}
      end
    end

    def attribute_table
      @attribute_table ||= {}
    end
  end
end
