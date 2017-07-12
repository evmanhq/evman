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

ActiveRecord::Schema.define(version: 20170711231240) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "unaccent"

  create_table "api_tokens", force: :cascade do |t|
    t.string "name", null: false
    t.string "token", null: false
    t.bigint "team_id"
    t.bigint "user_id"
    t.boolean "global", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_api_tokens_on_team_id"
    t.index ["user_id"], name: "index_api_tokens_on_user_id"
  end

  create_table "attachments", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "file_file_name"
    t.string "file_content_type"
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.integer "user_id"
    t.integer "parent_id"
    t.string "parent_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "attendee_types", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "default", default: false, null: false
  end

  create_table "attendees", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
    t.integer "attendee_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
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
    t.string "geoid", limit: 255
    t.integer "country_id"
    t.integer "time_zone_id"
    t.float "lat"
    t.float "lon"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "state_id"
    t.string "display", limit: 255
    t.index "to_tsvector('english'::regconfig, f_unaccent((display)::text))", name: "index_fulltext_cities", using: :gin
    t.index ["country_id"], name: "index_cities_on_country_id"
    t.index ["geoid"], name: "index_cities_on_geoid"
    t.index ["state_id"], name: "index_cities_on_state_id"
  end

  create_table "city_names", id: :serial, force: :cascade do |t|
    t.string "geoid", limit: 255
    t.string "name", limit: 255
    t.string "keyword", limit: 255
    t.integer "city_id"
    t.integer "language_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index "keyword varchar_pattern_ops", name: "index_city_names_on_keyword2"
    t.index ["city_id"], name: "index_city_names_on_city_id"
    t.index ["geoid"], name: "index_city_names_on_geoid"
    t.index ["keyword"], name: "index_city_names_on_keyword"
  end

  create_table "continents", id: :serial, force: :cascade do |t|
    t.string "code", limit: 255
    t.string "name", limit: 255
    t.string "geoid", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "countries", id: :serial, force: :cascade do |t|
    t.string "code", limit: 255
    t.string "name", limit: 255
    t.string "tld", limit: 255
    t.string "geoid", limit: 255
    t.integer "currency_id"
    t.integer "continent_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["continent_id"], name: "index_countries_on_continent_id"
  end

  create_table "currencies", id: :serial, force: :cascade do |t|
    t.string "code", limit: 255
    t.string "name", limit: 255
    t.string "symbol", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "email_change_requests", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "code", limit: 255
    t.string "email", limit: 255
    t.boolean "confirmed", default: false, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_notes", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "event_id"
    t.text "content"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "event_properties", force: :cascade do |t|
    t.string "name"
    t.bigint "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_event_properties_on_team_id"
  end

  create_table "event_property_options", force: :cascade do |t|
    t.string "name"
    t.bigint "property_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["property_id"], name: "index_event_property_options_on_property_id"
  end

  create_table "event_series", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_talks", id: :serial, force: :cascade do |t|
    t.integer "talk_id"
    t.integer "event_id"
    t.integer "user_id"
    t.boolean "state"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "event_types", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "team_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "default", default: false, null: false
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.boolean "committed"
    t.boolean "approved"
    t.boolean "archived"
    t.integer "city_id"
    t.string "location", limit: 255
    t.string "url", limit: 255
    t.string "sponsorship", limit: 255
    t.string "cfp_url", limit: 255
    t.date "cfp_date"
    t.date "begins_at"
    t.date "ends_at"
    t.integer "team_id"
    t.integer "owner_id"
    t.integer "event_series_id"
    t.integer "event_type_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "sponsorship_date"
    t.jsonb "properties_assignments"
    t.index ["city_id"], name: "index_events_on_city_id"
    t.index ["owner_id"], name: "index_events_on_owner_id"
    t.index ["properties_assignments"], name: "index_events_on_properties_assignments", using: :gin
    t.index ["team_id"], name: "index_events_on_team_id"
  end

  create_table "expense_types", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "team_id"
    t.boolean "default"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "expenses", id: :serial, force: :cascade do |t|
    t.integer "event_id"
    t.integer "user_id"
    t.integer "expense_type_id"
    t.string "report_id", limit: 255
    t.integer "item_id"
    t.string "item_type", limit: 255
    t.integer "count", default: 1
    t.float "amount"
    t.integer "currency_id"
    t.float "rate"
    t.float "usd"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
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
    t.string "provider", limit: 255
    t.string "uid", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "token", limit: 255
    t.string "secret", limit: 255
    t.datetime "expires"
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "languages", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "code", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "languages_organized_events", id: false, force: :cascade do |t|
    t.integer "organized_event_id", null: false
    t.integer "language_id", null: false
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "sender_id"
    t.string "sender_type", limit: 255
    t.string "subject", limit: 255
    t.text "content"
    t.boolean "read", default: false
    t.integer "message_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "monthly_goals", id: :serial, force: :cascade do |t|
    t.string "name", null: false
    t.integer "value", null: false
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "organized_event_difficulties", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_organized_event_difficulties_on_team_id"
  end

  create_table "organized_event_difficulties_events", id: false, force: :cascade do |t|
    t.integer "organized_event_id", null: false
    t.integer "organized_event_difficulty_id", null: false
  end

  create_table "organized_event_paper_types", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_organized_event_paper_types_on_team_id"
  end

  create_table "organized_event_paper_types_events", id: false, force: :cascade do |t|
    t.integer "organized_event_id", null: false
    t.integer "organized_event_paper_type_id", null: false
  end

  create_table "organized_event_papers", id: :serial, force: :cascade do |t|
    t.string "title"
    t.integer "track_id"
    t.integer "difficulty_id"
    t.integer "language_id"
    t.text "abstract"
    t.text "additional_notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "paper_type_id"
    t.index ["difficulty_id"], name: "index_organized_event_papers_on_difficulty_id"
    t.index ["language_id"], name: "index_organized_event_papers_on_language_id"
    t.index ["paper_type_id"], name: "index_organized_event_papers_on_paper_type_id"
    t.index ["track_id"], name: "index_organized_event_papers_on_track_id"
  end

  create_table "organized_event_speakers", id: :serial, force: :cascade do |t|
    t.boolean "primary"
    t.integer "user_id"
    t.integer "paper_id"
    t.integer "tshirt_size_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["paper_id"], name: "index_organized_event_speakers_on_paper_id"
    t.index ["tshirt_size_id"], name: "index_organized_event_speakers_on_tshirt_size_id"
    t.index ["user_id"], name: "index_organized_event_speakers_on_user_id"
  end

  create_table "organized_event_tracks", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "organized_event_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["organized_event_id"], name: "index_organized_event_tracks_on_organized_event_id"
  end

  create_table "organized_event_tshirt_sizes", id: :serial, force: :cascade do |t|
    t.string "name"
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["team_id"], name: "index_organized_event_tshirt_sizes_on_team_id"
  end

  create_table "organized_event_tshirt_sizes_events", id: false, force: :cascade do |t|
    t.integer "organized_event_id", null: false
    t.integer "organized_event_tshirt_size_id", null: false
  end

  create_table "organized_events", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "token"
    t.integer "team_id"
    t.integer "owner_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "description"
    t.string "logo_file_name"
    t.string "logo_content_type"
    t.integer "logo_file_size"
    t.datetime "logo_updated_at"
    t.index ["owner_id"], name: "index_organized_events_on_owner_id"
    t.index ["team_id"], name: "index_organized_events_on_team_id"
  end

  create_table "profile_pictures", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "image_file_name"
    t.string "image_content_type"
    t.integer "image_file_size"
    t.datetime "image_updated_at"
    t.boolean "public", default: false
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
    t.integer "user_id", null: false
    t.integer "role_id", null: false
  end

  create_table "sessions", id: :serial, force: :cascade do |t|
    t.string "session_id", limit: 255, null: false
    t.text "data"
    t.datetime "created_at"
    t.datetime "updated_at"
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
  end

  create_table "slack_users", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "slack_setting_id"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "states", id: :serial, force: :cascade do |t|
    t.string "geoid", limit: 255
    t.string "code", limit: 255
    t.string "name", limit: 255
    t.integer "country_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["geoid"], name: "index_states_on_geoid"
  end

  create_table "swag_items", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.float "price"
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "taggeds", id: :serial, force: :cascade do |t|
    t.integer "item_id"
    t.string "item_type", limit: 255
    t.integer "tag_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tags", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "keyword", limit: 255
    t.integer "team_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "talks", id: :serial, force: :cascade do |t|
    t.integer "team_id"
    t.integer "user_id"
    t.integer "event_type_id"
    t.integer "event_series_id"
    t.string "name", limit: 255
    t.text "abstract"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "archived", default: false
  end

  create_table "task_lists", id: :serial, force: :cascade do |t|
    t.integer "team_id"
    t.string "name", limit: 255
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "tasks", id: :serial, force: :cascade do |t|
    t.integer "task_list_id"
    t.string "name", limit: 255
    t.string "description", limit: 255
    t.datetime "due"
    t.integer "item_id"
    t.string "item_type", limit: 255
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_invitations", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255
    t.string "code", limit: 255, null: false
    t.integer "user_id"
    t.integer "team_id"
    t.boolean "accepted"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "team_membership_types", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.boolean "active"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "team_memberships", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "team_id"
    t.integer "team_membership_type_id"
    t.boolean "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["team_id"], name: "index_team_memberships_on_team_id"
    t.index ["user_id"], name: "index_team_memberships_on_user_id"
  end

  create_table "team_monthly_goals", id: :serial, force: :cascade do |t|
    t.integer "team_id"
    t.integer "value", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "teams", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "description"
    t.boolean "active"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "system", default: false
    t.boolean "public", default: false
    t.string "subdomain", null: false
    t.string "email_domain"
    t.integer "event_feedback_form_id"
    t.index ["event_feedback_form_id"], name: "index_teams_on_event_feedback_form_id"
  end

  create_table "teams_warehouses", id: false, force: :cascade do |t|
    t.integer "team_id", null: false
    t.integer "warehouse_id", null: false
    t.index ["team_id"], name: "index_teams_warehouses_on_team_id"
    t.index ["warehouse_id"], name: "index_teams_warehouses_on_warehouse_id"
  end

  create_table "time_zones", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
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

  create_table "user_monthly_goals", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "monthly_goal_id"
    t.text "comment"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255, default: ""
    t.string "email", limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "group_id"
    t.string "password_digest"
    t.string "token"
    t.string "job_title"
    t.integer "default_biography_id"
    t.integer "default_profile_picture_id"
    t.integer "home_country_id"
    t.string "organization"
    t.string "phone"
    t.string "twitter"
    t.string "github"
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
