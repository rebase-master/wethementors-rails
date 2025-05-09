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

ActiveRecord::Schema[7.2].define(version: 2024_03_06_000004) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "profile_options", force: :cascade do |t|
    t.string "name", null: false
    t.string "options", null: false
    t.text "description"
    t.boolean "required", default: false
    t.boolean "public", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_profile_options_on_name", unique: true
    t.index ["options"], name: "index_profile_options_on_options", unique: true
  end

  create_table "user_data", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "profile_option_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_option_id"], name: "index_user_data_on_profile_option_id"
    t.index ["user_id", "profile_option_id"], name: "index_user_data_on_user_id_and_profile_option_id", unique: true
    t.index ["user_id"], name: "index_user_data_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.boolean "admin", default: false
    t.string "type"
    t.string "access_token"
    t.string "password_digest", null: false
    t.string "registration_key"
    t.boolean "confirmed", default: false
    t.string "username", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.datetime "last_login"
    t.boolean "blocked", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_users_on_access_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["registration_key"], name: "index_users_on_registration_key"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  add_foreign_key "user_data", "profile_options"
  add_foreign_key "user_data", "users"
end
