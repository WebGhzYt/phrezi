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

ActiveRecord::Schema.define(version: 20150108064443) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: true do |t|
    t.string   "street1"
    t.string   "street2"
    t.string   "city"
    t.string   "state"
    t.string   "country"
    t.string   "postal"
    t.integer  "resource_id"
    t.string   "resource_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ballyhoo_days", force: true do |t|
    t.string   "day"
    t.integer  "repeat_type"
    t.date     "end_repeat"
    t.integer  "ballyhoo_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ballyhoo_transactions", force: true do |t|
    t.integer  "ballyhoo_id"
    t.integer  "challenge_id"
    t.integer  "user_id"
    t.integer  "point_amount"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "ballyhoos", force: true do |t|
    t.string   "title"
    t.text     "description"
    t.time     "start_time"
    t.time     "end_time"
    t.date     "start_date"
    t.integer  "repeat_type",       default: 0
    t.date     "end_repeat"
    t.string   "total_checkin_qty", default: ""
    t.boolean  "friends_sync",      default: false
    t.integer  "point_value"
    t.integer  "item_id"
    t.string   "ballyhoo_type"
    t.integer  "establishment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "enabled",           default: true
    t.integer  "friends"
    t.integer  "limit_person",      default: 1
    t.integer  "category_id"
    t.integer  "min_no_of_item",    default: 1
    t.string   "purchase_amount"
    t.boolean  "all_day",           default: false
    t.text     "repeating_days"
    t.integer  "point_multiplier"
    t.string   "product_category"
    t.integer  "point_addition"
    t.integer  "audience"
  end

  add_index "ballyhoos", ["establishment_id"], name: "index_ballyhoos_on_establishment_id", using: :btree

  create_table "booster_transactions", force: true do |t|
    t.integer  "points_scored"
    t.integer  "ballyhoo_id"
    t.integer  "challenge_id"
    t.integer  "establishment_id"
    t.integer  "loyal_patron_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "cart_boosters", force: true do |t|
    t.integer  "patron_cart_id"
    t.integer  "booster_id"
    t.integer  "quantity"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "categories", force: true do |t|
    t.string   "category"
    t.integer  "establishment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "challenges", force: true do |t|
    t.string   "name"
    t.datetime "start_date"
    t.datetime "end_date"
    t.decimal  "payout"
    t.integer  "establishment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "challenge_prize"
    t.decimal  "challenge_winner"
    t.decimal  "win_differential"
    t.decimal  "gross_sales",      precision: 11, scale: 2, default: 0.0
    t.string   "participants"
    t.boolean  "repeat",                                    default: false
    t.integer  "linked_with"
  end

  add_index "challenges", ["establishment_id"], name: "index_challenges_on_establishment_id", using: :btree

  create_table "checkin_ballyhoos", force: true do |t|
    t.boolean  "include_friends"
    t.boolean  "friends_sync"
    t.integer  "total_checkin_qty"
    t.integer  "point_value"
    t.datetime "ballyhoo_start"
    t.datetime "ballyhoo_end"
    t.date     "end_repeat"
    t.integer  "establishment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "repeat_type",       default: 0
  end

  add_index "checkin_ballyhoos", ["establishment_id"], name: "index_checkin_ballyhoos_on_establishment_id", using: :btree

  create_table "checkins", force: true do |t|
    t.integer  "establishment_id"
    t.integer  "user_id"
    t.datetime "start_time"
    t.datetime "end_time"
    t.integer  "total_checkin_qty"
    t.boolean  "include_friends",   default: false
    t.boolean  "friends_sync",      default: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checkins", ["establishment_id"], name: "index_checkins_on_establishment_id", using: :btree
  add_index "checkins", ["user_id"], name: "index_checkins_on_user_id", using: :btree

  create_table "delayed_jobs", force: true do |t|
    t.integer  "priority",   default: 0, null: false
    t.integer  "attempts",   default: 0, null: false
    t.text     "handler",                null: false
    t.text     "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string   "locked_by"
    t.string   "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "delayed_jobs", ["priority", "run_at"], name: "delayed_jobs_priority", using: :btree

  create_table "employees", force: true do |t|
    t.integer  "user_id"
    t.integer  "establishment_id"
    t.boolean  "enabled",          default: true
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "role",             default: 0
  end

  add_index "employees", ["establishment_id"], name: "index_employees_on_establishment_id", using: :btree
  add_index "employees", ["user_id"], name: "index_employees_on_user_id", using: :btree

  create_table "enrolled_challenges", force: true do |t|
    t.integer  "challenge_id"
    t.integer  "patron_id"
    t.integer  "current_points", default: 0
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "enrolled_challenges", ["challenge_id"], name: "index_enrolled_challenges_on_challenge_id", using: :btree

  create_table "establishment_hours", force: true do |t|
    t.integer  "establishment_id"
    t.string   "day"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.time     "open_time"
    t.time     "close_time"
    t.boolean  "closed",           default: false
  end

  add_index "establishment_hours", ["establishment_id"], name: "index_establishment_hours_on_establishment_id", using: :btree

  create_table "establishments", force: true do |t|
    t.string   "name"
    t.integer  "address_id"
    t.string   "phone"
    t.float    "gps_lat"
    t.float    "gps_long"
    t.string   "website"
    t.string   "facebook"
    t.string   "twitter"
    t.integer  "group_id"
    t.decimal  "point_dollar",         default: 1.0
    t.string   "default_currency"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "picture_file_name"
    t.string   "picture_content_type"
    t.integer  "picture_file_size"
    t.datetime "picture_updated_at"
    t.string   "timezone"
  end

  add_index "establishments", ["address_id"], name: "index_establishments_on_address_id", using: :btree
  add_index "establishments", ["group_id"], name: "index_establishments_on_group_id", using: :btree

  create_table "establishments_loyal_patrons", force: true do |t|
    t.integer  "establishment_id"
    t.integer  "loyal_patron_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "groups", force: true do |t|
    t.string   "name"
    t.string   "phone"
    t.integer  "address_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "groups", ["address_id"], name: "index_groups_on_address_id", using: :btree

  create_table "loyal_patrons", force: true do |t|
    t.string   "name"
    t.integer  "income"
    t.integer  "points"
    t.float    "credit"
    t.string   "facebook"
    t.string   "twitter"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "menu_items", force: true do |t|
    t.integer  "establishment_id"
    t.string   "name"
    t.string   "category"
    t.decimal  "price"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "menu_items", ["establishment_id"], name: "index_menu_items_on_establishment_id", using: :btree

  create_table "opro_auth_grants", force: true do |t|
    t.string   "code"
    t.string   "access_token"
    t.string   "refresh_token"
    t.text     "permissions"
    t.datetime "access_token_expires_at"
    t.integer  "user_id"
    t.integer  "application_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "opro_auth_grants", ["access_token"], name: "index_opro_auth_grants_on_access_token", unique: true, using: :btree
  add_index "opro_auth_grants", ["code"], name: "index_opro_auth_grants_on_code", unique: true, using: :btree
  add_index "opro_auth_grants", ["refresh_token"], name: "index_opro_auth_grants_on_refresh_token", unique: true, using: :btree

  create_table "opro_client_apps", force: true do |t|
    t.string   "name"
    t.string   "app_id"
    t.string   "app_secret"
    t.text     "permissions"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "opro_client_apps", ["app_id", "app_secret"], name: "index_opro_client_apps_on_app_id_and_app_secret", unique: true, using: :btree
  add_index "opro_client_apps", ["app_id"], name: "index_opro_client_apps_on_app_id", unique: true, using: :btree

  create_table "patron_carts", force: true do |t|
    t.decimal  "purchase_total"
    t.integer  "loyal_patron_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "establishment_id"
  end

  create_table "product_categories", force: true do |t|
    t.string   "name"
    t.integer  "default_points"
    t.integer  "establishment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "products", force: true do |t|
    t.string   "name"
    t.decimal  "cost"
    t.decimal  "price"
    t.boolean  "active"
    t.integer  "product_category_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "purchase_ballyhoos", force: true do |t|
    t.integer  "purchase_type"
    t.integer  "item_id"
    t.integer  "point_adjustment"
    t.string   "title"
    t.text     "description"
    t.datetime "ballyhoo_start"
    t.datetime "ballyhoo_end"
    t.date     "end_repeat"
    t.integer  "repeat_type"
    t.integer  "establishment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "purchase_ballyhoos", ["establishment_id"], name: "index_purchase_ballyhoos_on_establishment_id", using: :btree

  create_table "purchase_transactions", force: true do |t|
    t.string   "amount"
    t.integer  "loyal_patron_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: ""
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "last_name"
    t.string   "avatar_file_name"
    t.string   "avatar_content_type"
    t.integer  "avatar_file_size"
    t.datetime "avatar_updated_at"
    t.string   "invitation_token"
    t.datetime "invitation_created_at"
    t.datetime "invitation_sent_at"
    t.datetime "invitation_accepted_at"
    t.integer  "invitation_limit"
    t.integer  "invited_by_id"
    t.string   "invited_by_type"
    t.integer  "invitations_count",      default: 0
    t.boolean  "establishment_access",   default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["invitation_token"], name: "index_users_on_invitation_token", unique: true, using: :btree
  add_index "users", ["invitations_count"], name: "index_users_on_invitations_count", using: :btree
  add_index "users", ["invited_by_id"], name: "index_users_on_invited_by_id", using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree

end
