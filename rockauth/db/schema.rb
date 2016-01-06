# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150709084233) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "authentications", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.string   "resource_owner_type"
    t.integer  "provider_authentication_id"
    t.integer  "expiration"
    t.integer  "issued_at"
    t.string   "hashed_token_id"
    t.string   "auth_type",                  null: false
    t.string   "client_id",                  null: false
    t.string   "client_version"
    t.string   "device_identifier"
    t.string   "device_description"
    t.string   "device_os"
    t.string   "device_os_version"
    t.datetime "created_at",                 null: false
    t.datetime "updated_at",                 null: false
  end

  add_index "authentications", ["hashed_token_id"], name: "index_authentications_on_hashed_token_id", using: :btree
  add_index "authentications", ["provider_authentication_id"], name: "index_authentications_on_provider_authentication_id", using: :btree
  add_index "authentications", ["resource_owner_id", "resource_owner_type"], name: "index_authentications_on_resource_owner", using: :btree

  create_table "provider_authentications", force: :cascade do |t|
    t.integer  "resource_owner_id"
    t.string   "resource_owner_type"
    t.string   "provider",                     null: false
    t.string   "provider_user_id",             null: false
    t.string   "provider_access_token",        null: false
    t.string   "provider_access_token_secret"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  add_index "provider_authentications", ["provider", "provider_user_id"], name: "index_provider_authentications_provider_and_user_id", unique: true, using: :btree
  add_index "provider_authentications", ["provider_user_id"], name: "index_provider_authentications_on_provider_user_id", using: :btree
  add_index "provider_authentications", ["resource_owner_id", "resource_owner_type"], name: "index_provider_authentications_on_resource_owner", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.string   "password_digest"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree

  add_foreign_key "authentications", "provider_authentications"
end
