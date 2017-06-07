class CreateLocalizations < ActiveRecord::Migration[4.2]
  def change
    create_table :localizations do |t|
      t.references :localizable, polymorphic: true
      t.string :name
      t.string :locale
      t.text :value, limit: 16_777_215
      t.timestamps null: false
      t.index([:localizable_id, :localizable_type, :name, :locale],
              name: "index_localizations_on_locale")
      t.index [:localizable_id, :localizable_type]
    end
  end
end
