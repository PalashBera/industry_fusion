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

ActiveRecord::Schema.define(version: 2020_05_11_142440) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "approval_levels", force: :cascade do |t|
    t.string "approval_type", null: false
    t.bigint "organization_id", null: false
    t.bigint "updated_by_id"
    t.bigint "created_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["approval_type"], name: "index_approval_levels_on_approval_type"
    t.index ["created_by_id"], name: "index_approval_levels_on_created_by_id"
    t.index ["organization_id"], name: "index_approval_levels_on_organization_id"
    t.index ["updated_by_id"], name: "index_approval_levels_on_updated_by_id"
  end

  create_table "approvals", force: :cascade do |t|
    t.bigint "indent_item_id", null: false
    t.integer "level", null: false
    t.text "user_ids", default: [], array: true
    t.string "action_type"
    t.datetime "action_taken_at"
    t.bigint "action_taken_by_id"
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_id"], name: "index_approvals_on_created_by_id"
    t.index ["indent_item_id"], name: "index_approvals_on_indent_item_id"
    t.index ["updated_by_id"], name: "index_approvals_on_updated_by_id"
  end

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
    t.string "short_name", limit: 3, null: false
    t.string "address1", null: false
    t.string "address2", default: ""
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.bigint "logo_file_size"
    t.datetime "logo_updated_at"
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

  create_table "cost_centers", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", default: ""
    t.boolean "archive", default: false, null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_id"], name: "index_cost_centers_on_created_by_id"
    t.index ["organization_id"], name: "index_cost_centers_on_organization_id"
    t.index ["updated_by_id"], name: "index_cost_centers_on_updated_by_id"
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

  create_table "indent_items", force: :cascade do |t|
    t.bigint "indent_id", null: false
    t.bigint "item_id", null: false
    t.bigint "uom_id", null: false
    t.bigint "cost_center_id", null: false
    t.decimal "quantity", precision: 12, scale: 2, null: false
    t.string "priority", default: "default", null: false
    t.bigint "make_id"
    t.string "note", default: ""
    t.boolean "locked", default: false, null: false
    t.string "status", default: "pending", null: false
    t.integer "current_level", default: 0, null: false
    t.text "approval_ids", default: [], array: true
    t.bigint "organization_id", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["cost_center_id"], name: "index_indent_items_on_cost_center_id"
    t.index ["created_by_id"], name: "index_indent_items_on_created_by_id"
    t.index ["indent_id"], name: "index_indent_items_on_indent_id"
    t.index ["item_id"], name: "index_indent_items_on_item_id"
    t.index ["make_id"], name: "index_indent_items_on_make_id"
    t.index ["organization_id"], name: "index_indent_items_on_organization_id"
    t.index ["uom_id"], name: "index_indent_items_on_uom_id"
    t.index ["updated_by_id"], name: "index_indent_items_on_updated_by_id"
  end

  create_table "indentors", force: :cascade do |t|
    t.string "name", null: false
    t.boolean "archive", default: false, null: false
    t.bigint "organization_id", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_id"], name: "index_indentors_on_created_by_id"
    t.index ["organization_id"], name: "index_indentors_on_organization_id"
    t.index ["updated_by_id"], name: "index_indentors_on_updated_by_id"
  end

  create_table "indents", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.bigint "warehouse_id", null: false
    t.bigint "serial", null: false
    t.date "requirement_date", null: false
    t.bigint "indentor_id"
    t.bigint "organization_id", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["company_id"], name: "index_indents_on_company_id"
    t.index ["created_by_id"], name: "index_indents_on_created_by_id"
    t.index ["indentor_id"], name: "index_indents_on_indentor_id"
    t.index ["organization_id"], name: "index_indents_on_organization_id"
    t.index ["updated_by_id"], name: "index_indents_on_updated_by_id"
    t.index ["warehouse_id"], name: "index_indents_on_warehouse_id"
  end

  create_table "item_groups", force: :cascade do |t|
    t.string "name", null: false
    t.text "description", default: ""
    t.boolean "archive", default: false, null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.string "hsn_code", limit: 8
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_id"], name: "index_item_groups_on_created_by_id"
    t.index ["organization_id"], name: "index_item_groups_on_organization_id"
    t.index ["updated_by_id"], name: "index_item_groups_on_updated_by_id"
  end

  create_table "item_images", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.bigint "image_file_size"
    t.datetime "image_updated_at"
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_id"], name: "index_item_images_on_created_by_id"
    t.index ["item_id"], name: "index_item_images_on_item_id"
    t.index ["updated_by_id"], name: "index_item_images_on_updated_by_id"
  end

  create_table "items", force: :cascade do |t|
    t.bigint "item_group_id", null: false
    t.bigint "uom_id", null: false
    t.bigint "secondary_uom_id"
    t.string "name", null: false
    t.decimal "primary_quantity", precision: 10, scale: 2
    t.decimal "secondary_quantity", precision: 10, scale: 2
    t.boolean "archive", default: false, null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_id"], name: "index_items_on_created_by_id"
    t.index ["item_group_id"], name: "index_items_on_item_group_id"
    t.index ["organization_id"], name: "index_items_on_organization_id"
    t.index ["secondary_uom_id"], name: "index_items_on_secondary_uom_id"
    t.index ["uom_id"], name: "index_items_on_uom_id"
    t.index ["updated_by_id"], name: "index_items_on_updated_by_id"
  end

  create_table "level_users", force: :cascade do |t|
    t.bigint "approval_level_id", null: false
    t.bigint "user_id", null: false
    t.bigint "organization_id", null: false
    t.bigint "updated_by_id"
    t.bigint "created_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["approval_level_id"], name: "index_level_users_on_approval_level_id"
    t.index ["created_by_id"], name: "index_level_users_on_created_by_id"
    t.index ["organization_id"], name: "index_level_users_on_organization_id"
    t.index ["updated_by_id"], name: "index_level_users_on_updated_by_id"
    t.index ["user_id"], name: "index_level_users_on_user_id"
  end

  create_table "makes", force: :cascade do |t|
    t.bigint "brand_id", null: false
    t.bigint "item_id", null: false
    t.string "cat_no", default: ""
    t.boolean "archive", default: false, null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["brand_id"], name: "index_makes_on_brand_id"
    t.index ["created_by_id"], name: "index_makes_on_created_by_id"
    t.index ["item_id"], name: "index_makes_on_item_id"
    t.index ["organization_id"], name: "index_makes_on_organization_id"
    t.index ["updated_by_id"], name: "index_makes_on_updated_by_id"
  end

  create_table "organizations", force: :cascade do |t|
    t.string "name", null: false
    t.string "subdomain", null: false
    t.bigint "fy_start_month", null: false
    t.bigint "fy_end_month", null: false
    t.boolean "archive", default: false, null: false
    t.boolean "page_help_needed", default: true, null: false
    t.boolean "send_master_notification", default: true, null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_id"], name: "index_organizations_on_created_by_id"
    t.index ["updated_by_id"], name: "index_organizations_on_updated_by_id"
  end

  create_table "page_helps", force: :cascade do |t|
    t.string "controller_name", null: false
    t.string "action_name", null: false
    t.string "help_text", null: false
    t.string "help_type", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "reorder_levels", force: :cascade do |t|
    t.bigint "item_id", null: false
    t.bigint "warehouse_id", null: false
    t.decimal "quantity", precision: 10, scale: 2, null: false
    t.string "priority", default: "default", null: false
    t.boolean "archive", default: false, null: false
    t.bigint "organization_id", null: false
    t.bigint "updated_by_id"
    t.bigint "created_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_id"], name: "index_reorder_levels_on_created_by_id"
    t.index ["item_id"], name: "index_reorder_levels_on_item_id"
    t.index ["organization_id"], name: "index_reorder_levels_on_organization_id"
    t.index ["updated_by_id"], name: "index_reorder_levels_on_updated_by_id"
    t.index ["warehouse_id"], name: "index_reorder_levels_on_warehouse_id"
  end

  create_table "store_informations", force: :cascade do |t|
    t.bigint "vendor_id", null: false
    t.string "name", null: false
    t.string "address1", null: false
    t.string "address2", default: ""
    t.string "city", null: false
    t.string "state", null: false
    t.string "country", null: false
    t.string "pin_code", limit: 6, null: false
    t.string "phone_number", default: ""
    t.string "pan_number", limit: 10, null: false
    t.string "gstn", limit: 15, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["vendor_id"], name: "index_store_informations_on_vendor_id"
  end

  create_table "uoms", force: :cascade do |t|
    t.string "name", null: false
    t.string "short_name", limit: 4, null: false
    t.boolean "archive", default: false, null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.bigint "organization_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_id"], name: "index_uoms_on_created_by_id"
    t.index ["organization_id"], name: "index_uoms_on_organization_id"
    t.index ["updated_by_id"], name: "index_uoms_on_updated_by_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "mobile_number", default: "", null: false
    t.boolean "admin", default: false, null: false
    t.boolean "archive", default: false, null: false
    t.boolean "sidebar_collapse", default: false, null: false
    t.text "warehouse_ids", default: [], array: true
    t.bigint "organization_id", null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
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
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["created_by_id"], name: "index_users_on_created_by_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["invitation_token"], name: "index_users_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_users_on_invitations_count"
    t.index ["invited_by_type", "invited_by_id"], name: "index_users_on_invited_by_type_and_invited_by_id"
    t.index ["organization_id"], name: "index_users_on_organization_id"
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["updated_by_id"], name: "index_users_on_updated_by_id"
  end

  create_table "vendors", force: :cascade do |t|
    t.string "first_name", default: "", null: false
    t.string "last_name", default: "", null: false
    t.string "mobile_number", default: "", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
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
    t.string "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer "invitation_limit"
    t.string "invited_by_type"
    t.bigint "invited_by_id"
    t.integer "invitations_count"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["confirmation_token"], name: "index_vendors_on_confirmation_token", unique: true
    t.index ["email"], name: "index_vendors_on_email", unique: true
    t.index ["invitation_token"], name: "index_vendors_on_invitation_token", unique: true
    t.index ["invitations_count"], name: "index_vendors_on_invitations_count"
    t.index ["invited_by_type", "invited_by_id"], name: "index_vendors_on_invited_by_type_and_invited_by_id"
    t.index ["reset_password_token"], name: "index_vendors_on_reset_password_token", unique: true
  end

  create_table "vendorships", force: :cascade do |t|
    t.bigint "organization_id", null: false
    t.bigint "vendor_id", null: false
    t.boolean "archive", default: false, null: false
    t.bigint "created_by_id"
    t.bigint "updated_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_id"], name: "index_vendorships_on_created_by_id"
    t.index ["organization_id", "vendor_id"], name: "index_vendorships_on_organization_id_and_vendor_id", unique: true
    t.index ["organization_id"], name: "index_vendorships_on_organization_id"
    t.index ["updated_by_id"], name: "index_vendorships_on_updated_by_id"
    t.index ["vendor_id"], name: "index_vendorships_on_vendor_id"
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

  create_table "warehouse_locations", force: :cascade do |t|
    t.bigint "warehouse_id", null: false
    t.string "name", null: false
    t.boolean "archive", default: false, null: false
    t.bigint "organization_id", null: false
    t.bigint "updated_by_id"
    t.bigint "created_by_id"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["created_by_id"], name: "index_warehouse_locations_on_created_by_id"
    t.index ["organization_id"], name: "index_warehouse_locations_on_organization_id"
    t.index ["updated_by_id"], name: "index_warehouse_locations_on_updated_by_id"
    t.index ["warehouse_id"], name: "index_warehouse_locations_on_warehouse_id"
  end

  create_table "warehouses", force: :cascade do |t|
    t.bigint "company_id", null: false
    t.string "name", null: false
    t.string "short_name", limit: 3, null: false
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
    t.index ["company_id"], name: "index_warehouses_on_company_id"
    t.index ["created_by_id"], name: "index_warehouses_on_created_by_id"
    t.index ["organization_id"], name: "index_warehouses_on_organization_id"
    t.index ["updated_by_id"], name: "index_warehouses_on_updated_by_id"
  end

  add_foreign_key "approval_levels", "organizations"
  add_foreign_key "approvals", "indent_items"
  add_foreign_key "brands", "organizations"
  add_foreign_key "companies", "organizations"
  add_foreign_key "cost_centers", "organizations"
  add_foreign_key "indent_items", "cost_centers"
  add_foreign_key "indent_items", "indents"
  add_foreign_key "indent_items", "items"
  add_foreign_key "indent_items", "makes"
  add_foreign_key "indent_items", "organizations"
  add_foreign_key "indent_items", "uoms"
  add_foreign_key "indentors", "organizations"
  add_foreign_key "indents", "companies"
  add_foreign_key "indents", "indentors"
  add_foreign_key "indents", "organizations"
  add_foreign_key "indents", "warehouses"
  add_foreign_key "item_groups", "organizations"
  add_foreign_key "item_images", "items"
  add_foreign_key "items", "item_groups"
  add_foreign_key "items", "organizations"
  add_foreign_key "items", "uoms"
  add_foreign_key "items", "uoms", column: "secondary_uom_id"
  add_foreign_key "level_users", "approval_levels"
  add_foreign_key "level_users", "organizations"
  add_foreign_key "level_users", "users"
  add_foreign_key "makes", "brands"
  add_foreign_key "makes", "items"
  add_foreign_key "makes", "organizations"
  add_foreign_key "reorder_levels", "items"
  add_foreign_key "reorder_levels", "organizations"
  add_foreign_key "reorder_levels", "warehouses"
  add_foreign_key "uoms", "organizations"
  add_foreign_key "users", "organizations"
  add_foreign_key "vendorships", "organizations"
  add_foreign_key "vendorships", "vendors"
  add_foreign_key "warehouse_locations", "organizations"
  add_foreign_key "warehouse_locations", "warehouses"
  add_foreign_key "warehouses", "companies"
  add_foreign_key "warehouses", "organizations"
end
