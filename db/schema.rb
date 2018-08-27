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

ActiveRecord::Schema.define(version: 20180123070034) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "active_admin_comments", force: :cascade do |t|
    t.string   "namespace"
    t.text     "body"
    t.string   "resource_id",   null: false
    t.string   "resource_type", null: false
    t.string   "author_type"
    t.integer  "author_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.index ["author_type", "author_id"], name: "index_active_admin_comments_on_author_type_and_author_id", using: :btree
    t.index ["namespace"], name: "index_active_admin_comments_on_namespace", using: :btree
    t.index ["resource_type", "resource_id"], name: "index_active_admin_comments_on_resource_type_and_resource_id", using: :btree
  end

  create_table "admin_users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true, using: :btree
  end

  create_table "application_offers", force: :cascade do |t|
    t.integer  "application_id"
    t.integer  "offer_id"
    t.integer  "click_count",     default: 0
    t.datetime "last_clicked_at"
    t.index ["application_id"], name: "index_application_offers_on_application_id", using: :btree
    t.index ["offer_id"], name: "index_application_offers_on_offer_id", using: :btree
  end

  create_table "application_starts", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "application_type"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.index ["user_id"], name: "index_application_starts_on_user_id", using: :btree
  end

  create_table "applications", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "school"
    t.string   "period"
    t.string   "degree_type"
    t.string   "visa_type"
    t.string   "year_in_school"
    t.string   "expected_graduation"
    t.string   "employment_status"
    t.string   "employer"
    t.integer  "volume"
    t.float    "annual_income"
    t.float    "annual_income_others"
    t.float    "monthly_housing_payment"
    t.string   "citizenship_status"
    t.date     "dob"
    t.string   "phone_number"
    t.string   "current_street_address"
    t.string   "current_postal_code"
    t.string   "current_city"
    t.string   "current_state"
    t.string   "current_country"
    t.string   "home_street_address"
    t.string   "home_postal_code"
    t.string   "home_city"
    t.string   "home_state"
    t.string   "home_country"
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email"
    t.boolean  "accepted_terms"
    t.string   "has_cosigner"
    t.string   "cosigner_first_name"
    t.string   "cosigner_last_name"
    t.string   "cosigner_email"
    t.string   "cosigner_phone_number"
    t.text     "reason_for_loan"
    t.string   "housing_type"
    t.datetime "created_at",                                           null: false
    t.datetime "updated_at",                                           null: false
    t.string   "cosigner_country"
    t.string   "credit_score"
    t.string   "application_type",            default: "student_loan"
    t.string   "status"
    t.text     "reason_for_loan_personal"
    t.string   "phone_country_code"
    t.string   "cosigner_phone_country_code"
    t.integer  "reminder_emails_count"
    t.datetime "last_reminder_email_sent"
    t.integer  "outstanding_debts"
    t.string   "referral_source"
    t.index ["user_id"], name: "index_applications_on_user_id", using: :btree
  end

  create_table "contact_messages", force: :cascade do |t|
    t.string   "first_name"
    t.string   "last_name"
    t.string   "email_address"
    t.string   "phone_number"
    t.string   "product"
    t.text     "message"
    t.string   "referral_source"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "interests", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_interests_on_user_id", using: :btree
  end

  create_table "leads", force: :cascade do |t|
    t.string   "email"
    t.string   "referral_source"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "likely_application_offers", force: :cascade do |t|
    t.integer  "click_count",      default: 0
    t.datetime "last_clicked_at"
    t.integer  "user_id"
    t.integer  "application_id"
    t.integer  "offer_id"
    t.string   "application_type"
    t.index ["application_id"], name: "index_likely_application_offers_on_application_id", using: :btree
    t.index ["offer_id"], name: "index_likely_application_offers_on_offer_id", using: :btree
    t.index ["user_id"], name: "index_likely_application_offers_on_user_id", using: :btree
  end

  create_table "offer_clicks", force: :cascade do |t|
    t.integer  "offer_id"
    t.integer  "click_count"
    t.datetime "last_clicked_at"
    t.boolean  "likely"
    t.integer  "application_offer_id"
    t.integer  "user_id"
    t.integer  "application_id"
  end

  create_table "offer_rule_sets", force: :cascade do |t|
    t.integer "offer_id"
    t.string  "set_description"
    t.boolean "enabled",         default: true
    t.index ["offer_id"], name: "index_offer_rule_sets_on_offer_id", using: :btree
  end

  create_table "offer_rules", force: :cascade do |t|
    t.string  "attribute_name"
    t.text    "criteria"
    t.integer "offer_rule_set_id"
    t.index ["offer_rule_set_id"], name: "index_offer_rules_on_offer_rule_set_id", using: :btree
  end

  create_table "offers", force: :cascade do |t|
    t.string   "company_name"
    t.string   "apr_range"
    t.string   "fees"
    t.text     "borrower_protections"
    t.text     "amounts_available"
    t.string   "logo_file_name"
    t.string   "logo_content_type"
    t.integer  "logo_file_size"
    t.datetime "logo_updated_at"
    t.text     "url"
    t.boolean  "enabled",              default: true
    t.text     "description"
  end

  create_table "sent_emails", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "lead_id"
    t.integer  "application_id"
    t.string   "category"
    t.integer  "count",          default: 0
    t.datetime "last_sent_at"
    t.string   "email"
    t.datetime "created_at",                     null: false
    t.datetime "updated_at",                     null: false
    t.boolean  "disabled",       default: false
    t.index ["application_id"], name: "index_sent_emails_on_application_id", using: :btree
    t.index ["lead_id"], name: "index_sent_emails_on_lead_id", using: :btree
    t.index ["user_id"], name: "index_sent_emails_on_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "",  null: false
    t.string   "encrypted_password",     default: "",  null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,   null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "country"
    t.string   "first_name"
    t.string   "last_name"
    t.datetime "created_at",                           null: false
    t.datetime "updated_at",                           null: false
    t.string   "application_type"
    t.string   "application_completed",  default: "t"
    t.string   "referral_source"
    t.string   "promo_code"
    t.string   "username"
    t.text     "query_string"
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  end

end
