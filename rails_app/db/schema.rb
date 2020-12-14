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

ActiveRecord::Schema.define(version: 2020_11_29_022913) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "apex_profiles", force: :cascade do |t|
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "user_id", limit: 32
    t.string "apex_id", limit: 32
    t.integer "rank"
    t.integer "level"
    t.integer "platform"
    t.index ["user_id"], name: "index_apex_profiles_on_user_id"
  end

  create_table "favorite_legends", force: :cascade do |t|
    t.integer "apex_profile_id"
    t.integer "legend_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["apex_profile_id"], name: "index_favorite_legends_on_apex_profile_id"
    t.index ["legend_id"], name: "index_favorite_legends_on_legend_id"
  end

  create_table "favorite_weapons", force: :cascade do |t|
    t.integer "apex_profile_id"
    t.integer "weapon_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["apex_profile_id"], name: "index_favorite_weapons_on_apex_profile_id"
    t.index ["weapon_id"], name: "index_favorite_weapons_on_weapon_id"
  end

  create_table "legends", force: :cascade do |t|
    t.string "name", null: false
    t.string "icon_path", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "recruitings", force: :cascade do |t|
    t.string "type", null: false
    t.string "user_id", limit: 32, null: false
    t.integer "vc"
    t.integer "recruitment_numbers"
    t.text "play_style"
    t.integer "status", default: 0, null: false
    t.text "comment"
    t.integer "rank"
    t.integer "game_mode"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "users", primary_key: "user_id", id: :string, limit: 32, force: :cascade do |t|
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "name", limit: 16
    t.integer "sex", default: 0, null: false
    t.integer "age"
    t.text "introduce"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["user_id"], name: "index_users_on_user_id", unique: true
  end

  create_table "weapons", force: :cascade do |t|
    t.string "name", null: false
    t.integer "category", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  add_foreign_key "apex_profiles", "users", primary_key: "user_id"
end
