# encoding: utf-8

module LocalizableModel
  # = LocalizableModel::ScopeExtension
  #
  # Injected into the Relation when Model.localized is called.
  #
  module ScopeExtension
    attr_accessor :locale

    def localize(locale)
      @locale = locale
      self
    end

    def to_a
      super.map { |record| record.localize(@locale) }
    end
  end
end
