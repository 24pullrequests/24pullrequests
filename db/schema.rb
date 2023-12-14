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

ActiveRecord::Schema[7.1].define(version: 2021_12_12_143544) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"
  enable_extension "uuid-ossp"

  create_table "aggregation_filters", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "title_pattern"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_aggregation_filters_on_user_id"
  end

  create_table "archived_pull_requests", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "issue_url"
    t.text "body"
    t.string "state"
    t.boolean "merged"
    t.datetime "created_at", precision: nil
    t.string "repo_name"
    t.integer "user_id"
    t.string "language"
    t.integer "comments_count", default: 0
  end

  create_table "contributions", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "issue_url"
    t.text "body"
    t.string "state"
    t.boolean "merged"
    t.datetime "created_at", precision: nil
    t.string "repo_name"
    t.integer "user_id"
    t.string "language"
    t.integer "comments_count", default: 0
    t.integer "merged_by_id"
    t.index ["user_id"], name: "index_contributions_on_user_id"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.string "url"
    t.datetime "start_time", precision: nil
    t.decimal "latitude", precision: 10, scale: 6, default: "0.0"
    t.decimal "longitude", precision: 10, scale: 6, default: "0.0"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.text "description"
    t.integer "user_id"
    t.index ["start_time"], name: "index_events_on_start_time"
  end

  create_table "gifts", id: :serial, force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "contribution_id", null: false
    t.date "date", null: false
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id", "contribution_id"], name: "index_gifts_on_user_id_and_contribution_id", unique: true
  end

  create_table "labels", id: :serial, force: :cascade do |t|
    t.string "name"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
  end

  create_table "organisations", id: :serial, force: :cascade do |t|
    t.string "login"
    t.string "avatar_url"
    t.integer "github_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "contribution_count", default: 0
    t.index ["login"], name: "index_organisations_on_login", unique: true
  end

  create_table "organisations_users", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "organisation_id"
  end

  create_table "project_labels", id: :serial, force: :cascade do |t|
    t.integer "project_id"
    t.integer "label_id"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["label_id"], name: "index_project_labels_on_label_id"
    t.index ["project_id"], name: "index_project_labels_on_project_id"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.string "github_url"
    t.string "main_language"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.integer "user_id"
    t.boolean "inactive"
    t.boolean "featured", default: false
    t.string "avatar_url"
    t.integer "contribulator"
    t.string "homepage"
    t.string "contributing_url"
    t.datetime "last_scored", precision: nil
    t.boolean "fork"
    t.bigint "github_id"
  end

  create_table "pull_request_archives", id: :serial, force: :cascade do |t|
    t.string "title"
    t.string "issue_url"
    t.text "body"
    t.string "state"
    t.boolean "merged"
    t.datetime "created_at", precision: nil
    t.string "repo_name"
    t.integer "user_id"
    t.string "language"
    t.integer "comments_count", default: 0
  end

  create_table "skills", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.string "language"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.index ["user_id"], name: "index_skills_on_user_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.integer "uid", null: false
    t.string "provider", null: false
    t.string "nickname", null: false
    t.string "email"
    t.datetime "created_at", precision: nil, null: false
    t.datetime "updated_at", precision: nil, null: false
    t.string "gravatar_id"
    t.string "token"
    t.string "email_frequency"
    t.integer "contributions_count", default: 0
    t.datetime "last_sent_at", precision: nil
    t.string "twitter_token"
    t.string "twitter_secret"
    t.string "twitter_nickname"
    t.string "confirmation_token"
    t.datetime "confirmed_at", precision: nil
    t.string "name"
    t.string "blog"
    t.string "location"
    t.boolean "thank_you_email_sent", default: false
    t.decimal "lat", precision: 8, scale: 6
    t.decimal "lng", precision: 9, scale: 6
    t.string "ignored_organisations", default: [], array: true
    t.string "unsubscribe_token", null: false
    t.string "time_zone"
    t.boolean "invalid_token", default: false
    t.index ["nickname"], name: "index_users_on_nickname", unique: true
    t.index ["uid", "provider"], name: "index_users_on_uid_and_provider", unique: true
    t.index ["unsubscribe_token"], name: "index_users_on_unsubscribe_token", unique: true
  end

  add_foreign_key "aggregation_filters", "users"
end
