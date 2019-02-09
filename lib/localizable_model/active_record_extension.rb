# encoding: utf-8

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
      unless is_a?(LocalizableModel::ClassMethods)
        send :extend,  LocalizableModel::ClassMethods
        send :include, LocalizableModel::InstanceMethods
        has_many(:localizations,
                 as: :localizable,
                 dependent: :destroy,
                 autosave: true)
        before_save :cleanup_localizations!
      end
      localizable_configuration.instance_eval(&block) if block_given?
      define_localizable_methods!
    end
  end
end

ActiveRecord::Base.send(:extend, LocalizableModel::ActiveRecordExtension)
