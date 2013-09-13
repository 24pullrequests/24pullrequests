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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130913073803) do

  create_table "gifts", :force => true do |t|
    t.integer  "user_id",         :null => false
    t.integer  "pull_request_id", :null => false
    t.date     "date",            :null => false
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  add_index "gifts", ["user_id", "pull_request_id"], :name => "index_gifts_on_user_id_and_pull_request_id"

  create_table "projects", :force => true do |t|
    t.string   "name"
    t.text     "description"
    t.string   "github_url"
    t.string   "main_language"
    t.datetime "created_at",    :null => false
    t.datetime "updated_at",    :null => false
  end

  create_table "pull_requests", :force => true do |t|
    t.string   "title"
    t.string   "issue_url"
    t.text     "body"
    t.string   "state"
    t.boolean  "merged"
    t.datetime "created_at"
    t.string   "repo_name"
    t.integer  "user_id"
  end

  add_index "pull_requests", ["user_id"], :name => "index_pull_requests_on_user_id"

  create_table "skills", :force => true do |t|
    t.integer  "user_id"
    t.string   "language"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "skills", ["user_id"], :name => "index_skills_on_user_id"

  create_table "users", :force => true do |t|
    t.string   "uid",                                :null => false
    t.string   "provider",                           :null => false
    t.string   "nickname",                           :null => false
    t.string   "email"
    t.datetime "created_at",                         :null => false
    t.datetime "updated_at",                         :null => false
    t.string   "gravatar_id"
    t.string   "token"
    t.string   "email_frequency"
    t.integer  "pull_requests_count", :default => 0
    t.datetime "last_sent_at"
    t.string   "twitter_token"
    t.string   "twitter_secret"
    t.string   "twitter_nickname"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
  end

  add_index "users", ["nickname"], :name => "index_users_on_nickname"
  add_index "users", ["uid", "provider"], :name => "index_users_on_uid_and_provider"

end
