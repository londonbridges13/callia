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

ActiveRecord::Schema.define(version: 20170926022806) do

  create_table "activities", force: :cascade do |t|
    t.string   "activity"
    t.datetime "created_at",   null: false
    t.datetime "updated_at",   null: false
    t.integer  "office_id"
    t.integer  "call_id"
    t.integer  "client_id"
    t.integer  "caregiver_id"
    t.integer  "shift_id"
    t.integer  "user_id"
  end

  add_index "activities", ["call_id"], name: "index_activities_on_call_id"
  add_index "activities", ["caregiver_id"], name: "index_activities_on_caregiver_id"
  add_index "activities", ["client_id"], name: "index_activities_on_client_id"
  add_index "activities", ["office_id"], name: "index_activities_on_office_id"
  add_index "activities", ["shift_id"], name: "index_activities_on_shift_id"
  add_index "activities", ["user_id"], name: "index_activities_on_user_id"

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "admins", ["email"], name: "index_admins_on_email", unique: true
  add_index "admins", ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true

  create_table "calls", force: :cascade do |t|
    t.string   "caller_number"
    t.string   "called_number"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
    t.integer  "client_id"
    t.integer  "caregiver_id"
    t.integer  "shift_id"
    t.integer  "user_id"
    t.string   "log_type"
    t.string   "recorded_voice"
    t.string   "duration"
    t.datetime "clock_in"
    t.integer  "clock_out_call_id"
    t.integer  "clock_in_call_id"
  end

  add_index "calls", ["caregiver_id"], name: "index_calls_on_caregiver_id"
  add_index "calls", ["client_id"], name: "index_calls_on_client_id"
  add_index "calls", ["shift_id"], name: "index_calls_on_shift_id"
  add_index "calls", ["user_id"], name: "index_calls_on_user_id"

  create_table "caregivers", force: :cascade do |t|
    t.string   "name"
    t.string   "employee_code"
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "status"
    t.date     "birth_date"
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "office_id"
    t.integer  "user_id"
    t.string   "initial_recorded_voice"
    t.string   "phone_number"
  end

  add_index "caregivers", ["office_id"], name: "index_caregivers_on_office_id"
  add_index "caregivers", ["user_id"], name: "index_caregivers_on_user_id"

  create_table "clients", force: :cascade do |t|
    t.string   "name"
    t.string   "client_code"
    t.string   "authorized_phone"
    t.string   "status"
    t.datetime "created_at",       null: false
    t.datetime "updated_at",       null: false
    t.integer  "office_id"
    t.integer  "user_id"
    t.text     "notes"
    t.string   "location"
    t.string   "address"
    t.string   "postcode"
    t.string   "state"
    t.string   "city"
  end

  add_index "clients", ["office_id"], name: "index_clients_on_office_id"
  add_index "clients", ["user_id"], name: "index_clients_on_user_id"

  create_table "contacts", force: :cascade do |t|
    t.string   "email"
    t.string   "mobile_number"
    t.string   "home_number"
    t.text     "notes"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "caregiver_id"
    t.integer  "office_id"
    t.integer  "client_id"
  end

  add_index "contacts", ["caregiver_id"], name: "index_contacts_on_caregiver_id"
  add_index "contacts", ["client_id"], name: "index_contacts_on_client_id"
  add_index "contacts", ["office_id"], name: "index_contacts_on_office_id"

  create_table "coupons", force: :cascade do |t|
    t.string   "code"
    t.string   "free_trial_length"
    t.datetime "created_at",        null: false
    t.datetime "updated_at",        null: false
  end

  create_table "locations", force: :cascade do |t|
    t.string   "address"
    t.string   "city"
    t.string   "state"
    t.string   "postcode"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "office_id"
  end

  add_index "locations", ["office_id"], name: "index_locations_on_office_id"
  add_index "locations", ["user_id"], name: "index_locations_on_user_id"

  create_table "offices", force: :cascade do |t|
    t.string   "name"
    t.string   "telephone"
    t.string   "office_code"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
    t.integer  "user_id"
    t.integer  "supervisor_id"
    t.string   "location"
    t.string   "address"
    t.string   "postcode"
    t.string   "state"
    t.string   "city"
  end

  add_index "offices", ["user_id"], name: "index_offices_on_user_id"

  create_table "phone_numbers", force: :cascade do |t|
    t.string   "number"
    t.boolean  "is_used"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "phone_numbers", ["user_id"], name: "index_phone_numbers_on_user_id"

  create_table "plans", force: :cascade do |t|
    t.string   "name"
    t.string   "stripe_id"
    t.float    "price"
    t.string   "interval"
    t.text     "features"
    t.boolean  "highlight"
    t.integer  "display_order"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "recurring_shifts", force: :cascade do |t|
    t.integer  "frequency"
    t.string   "time_span"
    t.datetime "created_at",                         null: false
    t.datetime "updated_at",                         null: false
    t.string   "days",                default: "{}"
    t.datetime "end_recurrence_date"
  end

  create_table "reminders", force: :cascade do |t|
    t.string   "reminder"
    t.datetime "date"
    t.text     "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "reminders", ["user_id"], name: "index_reminders_on_user_id"

  create_table "sections", force: :cascade do |t|
    t.string   "section"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
  end

  add_index "sections", ["user_id"], name: "index_sections_on_user_id"

  create_table "services", force: :cascade do |t|
    t.text     "service"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer  "user_id"
    t.integer  "call_id"
    t.integer  "shift_id"
    t.string   "response"
    t.string   "section"
    t.string   "short_desc"
  end

  add_index "services", ["call_id"], name: "index_services_on_call_id"
  add_index "services", ["shift_id"], name: "index_services_on_shift_id"
  add_index "services", ["user_id"], name: "index_services_on_user_id"

  create_table "settings", force: :cascade do |t|
    t.string   "first_name"
    t.boolean  "allow_reminder_for_birthdays"
    t.datetime "created_at",                   null: false
    t.datetime "updated_at",                   null: false
  end

  create_table "shifts", force: :cascade do |t|
    t.datetime "start_time"
    t.datetime "end_time"
    t.float    "duration"
    t.text     "notes"
    t.string   "status"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
    t.integer  "caregiver_id"
    t.integer  "client_id"
    t.integer  "recurring_shift_id"
    t.integer  "office_id"
  end

  add_index "shifts", ["caregiver_id"], name: "index_shifts_on_caregiver_id"
  add_index "shifts", ["client_id"], name: "index_shifts_on_client_id"
  add_index "shifts", ["office_id"], name: "index_shifts_on_office_id"
  add_index "shifts", ["recurring_shift_id"], name: "index_shifts_on_recurring_shift_id"

  create_table "subscriptions", force: :cascade do |t|
    t.string   "stripe_id"
    t.integer  "plan_id"
    t.string   "last_four"
    t.integer  "coupon_id"
    t.string   "card_type"
    t.float    "current_price"
    t.integer  "user_id"
    t.datetime "created_at",    null: false
    t.datetime "updated_at",    null: false
  end

  create_table "users", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.string   "name"
    t.string   "agency_name"
    t.boolean  "is_admin"
    t.string   "agency_website"
    t.integer  "payroll"
    t.date     "next_payroll_day"
    t.string   "call_number"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.string   "time_zone"
    t.string   "agency_telephone"
    t.string   "address"
    t.integer  "calls_this_month",       default: 0
    t.datetime "next_billing_date"
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
