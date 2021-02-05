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

ActiveRecord::Schema.define(version: 2021_01_31_135647) do

  create_table "toots", force: :cascade do |t|
    t.integer "user_id"
    t.integer "twitter_authorization_id", null: false
    t.string "text", null: false
    t.string "tweet_id"
    t.datetime "sent_to_twitter_at"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.boolean "draft", default: false, null: false
    t.index ["twitter_authorization_id"], name: "index_toots_on_twitter_authorization_id"
    t.index ["user_id"], name: "index_toots_on_user_id"
  end

  create_table "twitter_authorizations", force: :cascade do |t|
    t.integer "user_id"
    t.string "oauth_token", null: false
    t.string "oauth_token_secret", null: false
    t.string "twitter_user_id", null: false
    t.string "handle", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["user_id", "twitter_user_id"], name: "index_twitter_authorizations_on_user_id_and_twitter_user_id", unique: true
    t.index ["user_id"], name: "index_twitter_authorizations_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "name"
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.string "time_zone", default: "UTC", null: false
  end

  add_foreign_key "toots", "twitter_authorizations", on_delete: :cascade
  add_foreign_key "toots", "users", on_delete: :cascade
  add_foreign_key "twitter_authorizations", "users", on_delete: :cascade
end
