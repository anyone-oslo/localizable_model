# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2016_05_06_141709) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "localizations", id: :serial, force: :cascade do |t|
    t.string "localizable_type"
    t.integer "localizable_id"
    t.string "name"
    t.string "locale"
    t.text "value"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["localizable_id", "localizable_type", "name", "locale"], name: "index_localizations_on_locale"
    t.index ["localizable_id", "localizable_type"], name: "index_localizations_on_localizable_id_and_localizable_type"
  end

  create_table "pages", id: :serial, force: :cascade do |t|
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
