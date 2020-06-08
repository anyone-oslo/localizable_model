# frozen_string_literal: true

require "rails/generators/active_record/migration"

module LocalizableModel
  module Generators
    class MigrationGenerator < Rails::Generators::Base
      include ActiveRecord::Generators::Migration

      desc "Creates the LocalizableModel migration"
      source_root File.expand_path("templates", __dir__)

      def copy_files
        migration_template(
          "create_localizations.rb",
          "db/migrate/create_localizations.rb"
        )
      end
    end
  end
end
