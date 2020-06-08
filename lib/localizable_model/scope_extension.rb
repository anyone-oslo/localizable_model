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

    protected

    def localize_records
      @records.each { |r| r.localize!(@locale) }
    end
  end
end
