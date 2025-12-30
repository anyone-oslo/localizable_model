# frozen_string_literal: true

module LocalizableModel
  # = LocalizableModel::ScopeExtension
  #
  # Injected into the Relation when Model.localized is called.
  #
  module ScopeExtension
    attr_accessor :locale

    def localize(locale)
      @locale = locale
      localize_records if loaded?
      self
    end

    def load
      super
      localize_records
      self
    end

    # Orders results by localized attribute values.
    #
    #   Product.in_locale(:nb).order_by_localization(:name)
    #   Product.in_locale(:en).order_by_localization(:name, :description)
    #
    def order_by_localization(*attributes)
      attributes = attributes.flatten.map(&:to_s)

      require_localized_attributes!(attributes)
      order(*attributes.map { |attr| order_by_localization_clause(attr) })
    end

    protected

    def localize_records
      @records.each { |r| r.localize!(@locale) }
    end

    private

    def localization_values
      Localization
        .arel_table
        .project(Localization.arel_table[:value])
        .where(Localization.arel_table[:localizable_id].eq(arel_table[:id]))
        .where(Localization.arel_table[:localizable_type].eq(name))
    end

    def order_by_localization_clause(attribute)
      Arel::Nodes::Ascending.new(
        localization_values
          .where(Localization.arel_table[:name].eq(attribute))
          .where(Localization.arel_table[:locale].eq(@locale.to_s))
      ).nulls_last
    end

    def require_localized_attributes!(attributes)
      raise ArgumentError, "No attributes specified" if attributes.empty?

      invalid = attributes.reject do |attr|
        klass.localized_attributes.include?(attr.to_sym)
      end
      return if invalid.empty?

      raise ArgumentError, "#{invalid.join(', ')} are not localized attributes"
    end
  end
end
