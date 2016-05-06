class CreateLocalizations < ActiveRecord::Migration
  def change
    create_table :localizations do |t|
      t.references :localizable, polymorphic: true
      t.string :name
      t.string :locale
      t.text :value, limit: 16_777_215
      t.timestamps null: false
    end
  end
end
