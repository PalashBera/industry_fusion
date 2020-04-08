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

ActiveRecord::Schema.define(version: 2020_03_30_151408) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "brands", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "archive", default: false, null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_id"], name: "index_brands_on_created_by_id"
    t.index ["organization_id"], name: "index_brands_on_organization_id"
    t.index ["updated_by_id"], name: "index_brands_on_updated_by_id"
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", null: false
    t.string "address1", null: false
    t.string "address2", default: ""
    t.string "city", null: false
    t.string "state", null: false
    t.string "country", null: false
    t.string "pin_code", limit: 6, null: false
    t.string "phone_number", default: ""
    t.boolean "archive", default: false, null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_id"], name: "index_companies_on_created_by_id"
    t.index ["organization_id"], name: "index_companies_on_organization_id"
    t.index ["updated_by_id"], name: "index_companies_on_updated_by_id"
  end

  create_table "delayed_jobs", force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at", precision: 6
    t.datetime "updated_at", precision: 6
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.string "address1", null: false
    t.string "address2", default: ""
    t.string "city", null: false
    t.string "state", null: false
    t.string "country", null: false
    t.string "pin_code", limit: 6, null: false
    t.text "description", default: ""
    t.boolean "archive", default: false, null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_id"], name: "index_organizations_on_created_by_id"
    t.index ["updated_by_id"], name: "index_organizations_on_updated_by_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "mobile_number", default: "", null: false
    t.boolean "admin", default: false, null: false
    t.bigint "organization_id"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.string "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  create_table "versions", force: :cascade do |t|
    t.string "item_type", null: false
    t.bigint "item_id", null: false
    t.string "event", null: false
    t.string "whodunnit"
    t.text "object_changes"
    t.datetime "created_at"
    t.index ["item_type", "item_id"], name: "index_versions_on_item_type_and_item_id"
  end

  add_foreign_key "brands", "organizations"
  add_foreign_key "companies", "organizations"
  add_foreign_key "users", "organizations"
end
