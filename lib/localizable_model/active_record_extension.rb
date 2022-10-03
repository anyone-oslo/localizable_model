# frozen_string_literal: true

module LocalizableModel
  # = LocalizableModel::ActiveRecordExtension
  #
  # Extends ActiveRecord::Base with the localizable setup method.
  #
  module ActiveRecordExtension
    # Extends the model with Localizable features.
    # It takes an optional block as argument, which yields an instance of
    # LocalizableModel::Configuration.
    #
    # Example:
    #
    #  class Page < ActiveRecord::Base
    #    localizable do
    #      attribute :name
    #      attribute :body
    #    end
    #  end
    #
    def localizable(&block)
      extend_with_localizable_model!
      localizable_configuration.instance_eval(&block) if block_given?
      define_localizable_methods!
    end

    def extend_with_localizable_model!
      return if is_a?(LocalizableModel::ClassMethods)

      send :extend,  LocalizableModel::ClassMethods
      send :include, LocalizableModel::InstanceMethods
      has_many(:localizations,
               as: :localizable,
               dependent: :destroy,
               autosave: true)
      before_save :cleanup_localizations!
    end
  end
end

ActiveSupport.on_load(:active_record) do
  extend LocalizableModel::ActiveRecordExtension
end
