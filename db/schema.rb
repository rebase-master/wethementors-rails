# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[7.2].define(version: 2025_05_14_065520) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "notes", force: :cascade do |t|
    t.bigint "notes_category_id", null: false
    t.bigint "notes_sub_category_id", null: false
    t.string "slug", null: false
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notes_category_id"], name: "index_notes_on_notes_category_id"
    t.index ["notes_sub_category_id"], name: "index_notes_on_notes_sub_category_id"
    t.index ["slug"], name: "index_notes_on_slug", unique: true
  end

  create_table "notes_categories", force: :cascade do |t|
    t.string "category"
    t.string "type"
    t.boolean "visible"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes_contents", force: :cascade do |t|
    t.bigint "note_id", null: false
    t.string "heading", null: false
    t.string "slug", null: false
    t.string "cover_image"
    t.text "content", null: false
    t.string "extract"
    t.string "source"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["note_id"], name: "index_notes_contents_on_note_id"
    t.index ["slug"], name: "index_notes_contents_on_slug", unique: true
  end

  create_table "notes_sub_categories", force: :cascade do |t|
    t.bigint "notes_category_id", null: false
    t.string "sub_category"
    t.boolean "visible"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notes_category_id"], name: "index_notes_sub_categories_on_notes_category_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "name"
    t.string "role"
    t.string "status"
    t.datetime "last_login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "notes", "notes_categories"
  add_foreign_key "notes", "notes_sub_categories"
  add_foreign_key "notes_contents", "notes"
  add_foreign_key "notes_sub_categories", "notes_categories"
end
