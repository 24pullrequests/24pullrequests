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

ActiveRecord::Schema.define(version: 20141215161710) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "archived_pull_requests", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.string   "issue_url",      limit: 255
    t.text     "body"
    t.string   "state",          limit: 255
    t.boolean  "merged"
    t.datetime "created_at"
    t.string   "repo_name",      limit: 255
    t.integer  "user_id"
    t.string   "language",       limit: 255
    t.integer  "comments_count",             default: 0
  end

  create_table "events", force: :cascade do |t|
    t.string   "name",        limit: 255
    t.string   "location",    limit: 255
    t.string   "url",         limit: 255
    t.datetime "start_time"
    t.decimal  "latitude",                precision: 10, scale: 6
    t.decimal  "longitude",               precision: 10, scale: 6
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "description"
    t.integer  "user_id"
  end

  add_index "events", ["start_time"], name: "index_events_on_start_time", using: :btree

  create_table "gifts", force: :cascade do |t|
    t.integer  "user_id",         null: false
    t.integer  "pull_request_id", null: false
    t.date     "date",            null: false
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "gifts", ["user_id", "pull_request_id"], name: "index_gifts_on_user_id_and_pull_request_id", unique: true, using: :btree

  create_table "labels", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "organisations", force: :cascade do |t|
    t.string   "login",              limit: 255
    t.string   "avatar_url",         limit: 255
    t.integer  "github_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "pull_request_count",             default: 0
  end

  add_index "organisations", ["login"], name: "index_organisations_on_login", unique: true, using: :btree

  create_table "organisations_users", force: :cascade do |t|
    t.integer "user_id"
    t.integer "organisation_id"
  end

  create_table "project_labels", force: :cascade do |t|
    t.integer  "project_id"
    t.integer  "label_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "project_labels", ["label_id"], name: "index_project_labels_on_label_id", using: :btree
  add_index "project_labels", ["project_id"], name: "index_project_labels_on_project_id", using: :btree

  create_table "projects", force: :cascade do |t|
    t.string   "name",          limit: 255
    t.text     "description"
    t.string   "github_url",    limit: 255
    t.string   "main_language", limit: 255
    t.datetime "created_at",                null: false
    t.datetime "updated_at",                null: false
    t.integer  "user_id"
    t.boolean  "inactive"
  end

  create_table "pull_request_archives", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.string   "issue_url",      limit: 255
    t.text     "body"
    t.string   "state",          limit: 255
    t.boolean  "merged"
    t.datetime "created_at"
    t.string   "repo_name",      limit: 255
    t.integer  "user_id"
    t.string   "language",       limit: 255
    t.integer  "comments_count",             default: 0
  end

  create_table "pull_requests", force: :cascade do |t|
    t.string   "title",          limit: 255
    t.string   "issue_url",      limit: 255
    t.text     "body"
    t.string   "state",          limit: 255
    t.boolean  "merged"
    t.datetime "created_at"
    t.string   "repo_name",      limit: 255
    t.integer  "user_id"
    t.integer  "comments_count",             default: 0
    t.string   "language",       limit: 255
  end

  add_index "pull_requests", ["user_id"], name: "index_pull_requests_on_user_id", using: :btree

  create_table "skills", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "language",   limit: 255
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
  end

  add_index "skills", ["user_id"], name: "index_skills_on_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string   "uid",                 limit: 255,             null: false
    t.string   "provider",            limit: 255,             null: false
    t.string   "nickname",            limit: 255,             null: false
    t.string   "email",               limit: 255
    t.datetime "created_at",                                  null: false
    t.datetime "updated_at",                                  null: false
    t.string   "gravatar_id",         limit: 255
    t.string   "token",               limit: 255
    t.string   "email_frequency",     limit: 255
    t.integer  "pull_requests_count",             default: 0
    t.datetime "last_sent_at"
    t.string   "twitter_token",       limit: 255
    t.string   "twitter_secret",      limit: 255
    t.string   "twitter_nickname",    limit: 255
    t.string   "confirmation_token",  limit: 255
    t.datetime "confirmed_at"
    t.string   "coderwall_user_name", limit: 255
    t.string   "name"
    t.string   "blog"
    t.string   "location"
  end

  add_index "users", ["nickname"], name: "index_users_on_nickname", using: :btree
  add_index "users", ["uid", "provider"], name: "index_users_on_uid_and_provider", using: :btree

end
