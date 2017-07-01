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

ActiveRecord::Schema.define(version: 20170613232128) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "attachments", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.integer "user_id"
    t.string "parent_type"
    t.integer "parent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["parent_type", "parent_id"], name: "index_attachments_on_parent_type_and_parent_id"
    t.index ["user_id"], name: "index_attachments_on_user_id"
  end

  create_table "attendee_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "team_id"
    t.boolean "default", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_attendee_types_on_team_id"
  end

  create_table "attendees", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
    t.integer "attendee_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["attendee_type_id"], name: "index_attendees_on_attendee_type_id"
    t.index ["event_id"], name: "index_attendees_on_event_id"
    t.index ["user_id"], name: "index_attendees_on_user_id"
  end

  create_table "biographies", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "name"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "cities", id: :serial, force: :cascade do |t|
    t.string "geoid"
    t.integer "country_id"
    t.integer "time_zone_id"
    t.float "lat"
    t.float "lon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state_id"
    t.string "display"
    t.index "to_tsvector('english'::regconfig, f_unaccent((display)::text))", name: "index_fulltext_cities", using: :gin
    t.index ["country_id"], name: "index_cities_on_country_id"
    t.index ["geoid"], name: "index_cities_on_geoid"
    t.index ["time_zone_id"], name: "index_cities_on_time_zone_id"
  end

  create_table "city_names", id: :serial, force: :cascade do |t|
    t.string "geoid"
    t.string "name"
    t.string "keyword"
    t.integer "city_id"
    t.integer "language_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_city_names_on_city_id"
    t.index ["geoid"], name: "index_city_names_on_geoid"
    t.index ["keyword"], name: "index_city_names_on_keyword"
    t.index ["language_id"], name: "index_city_names_on_language_id"
  end

  create_table "continents", id: :serial, force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "geoid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "countries", id: :serial, force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "tld"
    t.string "geoid"
    t.integer "currency_id"
    t.integer "continent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["continent_id"], name: "index_countries_on_continent_id"
    t.index ["currency_id"], name: "index_countries_on_currency_id"
  end

  create_table "currencies", id: :serial, force: :cascade do |t|
    t.string "code"
    t.string "name"
    t.string "symbol"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_notes", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_notes_on_event_id"
    t.index ["user_id"], name: "index_event_notes_on_user_id"
  end

  create_table "event_series", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_event_series_on_team_id"
  end

  create_table "event_talks", id: :serial, force: :cascade do |t|
    t.integer "talk_id"
    t.integer "event_id"
    t.integer "user_id"
    t.boolean "state"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_talks_on_event_id"
    t.index ["talk_id"], name: "index_event_talks_on_talk_id"
    t.index ["user_id"], name: "index_event_talks_on_user_id"
  end

  create_table "event_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "team_id"
    t.boolean "default", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_event_types_on_team_id"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "committed"
    t.boolean "approved"
    t.boolean "archived"
    t.integer "city_id"
    t.string "location"
    t.string "url"
    t.string "sponsorship"
    t.date "sponsorship_date"
    t.string "cfp_url"
    t.date "cfp_date"
    t.date "begins_at"
    t.date "ends_at"
    t.integer "team_id"
    t.integer "owner_id"
    t.integer "event_series_id"
    t.integer "event_type_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["city_id"], name: "index_events_on_city_id"
    t.index ["event_series_id"], name: "index_events_on_event_series_id"
    t.index ["event_type_id"], name: "index_events_on_event_type_id"
    t.index ["owner_id"], name: "index_events_on_owner_id"
    t.index ["team_id"], name: "index_events_on_team_id"
  end

  create_table "expense_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "team_id"
    t.boolean "default"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_expense_types_on_team_id"
  end

  create_table "expenses", id: :serial, force: :cascade do |t|
    t.integer "event_id"
    t.integer "user_id"
    t.integer "expense_type_id"
    t.string "report_id"
    t.float "amount"
    t.integer "currency_id"
    t.float "rate"
    t.float "usd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["currency_id"], name: "index_expenses_on_currency_id"
    t.index ["event_id"], name: "index_expenses_on_event_id"
    t.index ["expense_type_id"], name: "index_expenses_on_expense_type_id"
    t.index ["user_id"], name: "index_expenses_on_user_id"
  end

  create_table "form_submissions", id: :serial, force: :cascade do |t|
    t.integer "submitted_by_id"
    t.integer "form_id"
    t.jsonb "data"
    t.integer "associated_object_id"
    t.string "associated_object_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "form_structure_hash", limit: 32
    t.index ["associated_object_type", "associated_object_id"], name: "asociated_object_index"
    t.index ["form_id"], name: "index_form_submissions_on_form_id"
    t.index ["submitted_by_id"], name: "index_form_submissions_on_submitted_by_id"
  end

  create_table "forms", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "description"
    t.boolean "published", default: false
    t.integer "team_id"
    t.jsonb "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_forms_on_team_id"
  end

  create_table "identities", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "provider"
    t.string "uid"
    t.string "token"
    t.string "secret"
    t.datetime "expires"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "languages", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "code"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "profile_pictures", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.boolean "public", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.index ["user_id"], name: "index_profile_pictures_on_user_id"
  end

  create_table "roles", id: :serial, force: :cascade do |t|
    t.string "name"
    t.jsonb "authorization_profile"
    t.integer "team_id"
    t.boolean "default", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_roles_on_team_id"
  end

  create_table "roles_users", id: false, force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "role_id", null: false
  end

  create_table "sessions", id: :serial, force: :cascade do |t|
    t.string "session_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true
    t.index ["updated_at"], name: "index_sessions_on_updated_at"
  end

  create_table "slack_settings", id: :serial, force: :cascade do |t|
    t.integer "team_id"
    t.string "access_token"
    t.string "scope"
    t.string "team_name"
    t.string "team_uid"
    t.string "hook_channel"
    t.string "hook_channel_id"
    t.string "hook_configuration"
    t.string "hook_url"
    t.string "bot_id"
    t.string "bot_token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_slack_settings_on_team_id"
  end

  create_table "slack_users", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "slack_setting_id"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slack_setting_id"], name: "index_slack_users_on_slack_setting_id"
    t.index ["user_id"], name: "index_slack_users_on_user_id"
  end

  create_table "states", id: :serial, force: :cascade do |t|
    t.string "geoid"
    t.string "code"
    t.string "name"
    t.integer "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["country_id"], name: "index_states_on_country_id"
    t.index ["geoid"], name: "index_states_on_geoid"
  end

  create_table "taggeds", id: :serial, force: :cascade do |t|
    t.string "item_type"
    t.integer "item_id"
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_type", "item_id"], name: "index_taggeds_on_item_type_and_item_id"
    t.index ["tag_id"], name: "index_taggeds_on_tag_id"
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "keyword"
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_tags_on_team_id"
  end

  create_table "talks", id: :serial, force: :cascade do |t|
    t.integer "team_id"
    t.integer "user_id"
    t.integer "event_type_id"
    t.integer "event_series_id"
    t.string "name"
    t.text "abstract"
    t.boolean "archived", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_series_id"], name: "index_talks_on_event_series_id"
    t.index ["event_type_id"], name: "index_talks_on_event_type_id"
    t.index ["team_id"], name: "index_talks_on_team_id"
    t.index ["user_id"], name: "index_talks_on_user_id"
  end

  create_table "team_invitations", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "code", null: false
    t.integer "user_id"
    t.integer "team_id"
    t.boolean "accepted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_team_invitations_on_team_id"
    t.index ["user_id"], name: "index_team_invitations_on_user_id"
  end

  create_table "team_membership_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_memberships", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "team_id"
    t.integer "team_membership_type_id"
    t.boolean "active"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_team_memberships_on_team_id"
    t.index ["team_membership_type_id"], name: "index_team_memberships_on_team_membership_type_id"
    t.index ["user_id"], name: "index_team_memberships_on_user_id"
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "email_domain"
    t.boolean "active"
    t.string "subdomain", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "event_feedback_form_id"
    t.index ["event_feedback_form_id"], name: "index_teams_on_event_feedback_form_id"
  end

  create_table "teams_warehouses", id: false, force: :cascade do |t|
    t.bigint "team_id", null: false
    t.bigint "warehouse_id", null: false
    t.index ["team_id"], name: "index_teams_warehouses_on_team_id"
    t.index ["warehouse_id"], name: "index_teams_warehouses_on_warehouse_id"
  end

  create_table "time_zones", id: :serial, force: :cascade do |t|
    t.string "name"
    t.float "gmt"
    t.float "dst"
    t.float "dst_starts_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "user_emails", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "email"
    t.boolean "active", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_user_emails_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "token"
    t.string "password_digest"
    t.integer "home_country_id"
    t.string "job_title"
    t.string "organization"
    t.string "phone"
    t.string "twitter"
    t.string "github"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "default_biography_id"
    t.integer "default_profile_picture_id"
    t.index ["default_biography_id"], name: "index_users_on_default_biography_id"
    t.index ["default_profile_picture_id"], name: "index_users_on_default_profile_picture_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["home_country_id"], name: "index_users_on_home_country_id"
  end

  create_table "warehouse_batches", id: :serial, force: :cascade do |t|
    t.integer "item_id"
    t.decimal "price", precision: 11, scale: 2
    t.integer "total"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["item_id"], name: "index_warehouse_batches_on_item_id"
  end

  create_table "warehouse_items", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "warehouse_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["warehouse_id"], name: "index_warehouse_items_on_warehouse_id"
  end

  create_table "warehouse_transactions", id: :serial, force: :cascade do |t|
    t.integer "count", default: 0
    t.integer "returned", default: 0
    t.integer "total", default: 0
    t.string "description"
    t.integer "batch_id"
    t.integer "event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["batch_id"], name: "index_warehouse_transactions_on_batch_id"
    t.index ["event_id"], name: "index_warehouse_transactions_on_event_id"
  end

  create_table "warehouses", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

end
