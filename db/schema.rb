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

ActiveRecord::Schema[7.1].define(version: 2025_04_02_080724) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "account_users", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "user_id", null: false
    t.string "role", default: "mem", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["account_id"], name: "index_account_users_on_account_id"
    t.index ["deleted_at"], name: "index_account_users_on_deleted_at"
    t.index ["user_id"], name: "index_account_users_on_user_id"
  end

  create_table "accounts", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_accounts_on_deleted_at"
  end

  create_table "activity_logs", force: :cascade do |t|
    t.string "loggable_type"
    t.bigint "loggable_id"
    t.bigint "user_id"
    t.bigint "account_id", null: false
    t.string "action", null: false
    t.string "description", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["account_id"], name: "index_activity_logs_on_account_id"
    t.index ["deleted_at"], name: "index_activity_logs_on_deleted_at"
    t.index ["loggable_type", "loggable_id"], name: "index_activity_logs_on_loggable"
    t.index ["user_id"], name: "index_activity_logs_on_user_id"
  end

  create_table "data_exports", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "account_id", null: false
    t.string "export_type", null: false
    t.string "status", default: "pending", null: false
    t.text "file_data"
    t.text "error_message"
    t.datetime "started_at"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_data_exports_on_account_id"
    t.index ["user_id"], name: "index_data_exports_on_user_id"
  end

  create_table "twilio_requests", force: :cascade do |t|
    t.bigint "account_id", null: false
    t.bigint "user_id"
    t.string "endpoint", null: false
    t.string "api_version", null: false
    t.text "request_body", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["account_id"], name: "index_twilio_requests_on_account_id"
    t.index ["user_id"], name: "index_twilio_requests_on_user_id"
  end

  create_table "twilio_responses", force: :cascade do |t|
    t.bigint "twilio_request_id", null: false
    t.integer "http_status"
    t.text "response_body", null: false
    t.string "message_sid"
    t.string "call_sid"
    t.string "verification_sid"
    t.string "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["twilio_request_id"], name: "index_twilio_responses_on_twilio_request_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "crypted_password"
    t.string "password_salt"
    t.string "persistence_token"
    t.string "single_access_token"
    t.string "perishable_token"
    t.integer "login_count", default: 0, null: false
    t.integer "failed_login_count", default: 0, null: false
    t.datetime "last_request_at"
    t.datetime "current_login_at"
    t.datetime "last_login_at"
    t.string "current_login_ip"
    t.string "last_login_ip"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "deleted_at"
    t.index ["deleted_at"], name: "index_users_on_deleted_at"
    t.index ["email"], name: "index_users_on_email", unique: true
  end

  add_foreign_key "account_users", "accounts"
  add_foreign_key "account_users", "users"
  add_foreign_key "activity_logs", "accounts"
  add_foreign_key "activity_logs", "users"
  add_foreign_key "data_exports", "accounts"
  add_foreign_key "data_exports", "users"
  add_foreign_key "twilio_requests", "accounts"
  add_foreign_key "twilio_requests", "users"
  add_foreign_key "twilio_responses", "twilio_requests"
end
