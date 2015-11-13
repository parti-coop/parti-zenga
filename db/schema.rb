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

ActiveRecord::Schema.define(version: 20151110064133) do

  create_table "comments", force: :cascade do |t|
    t.text     "contents",       null: false
    t.integer  "issue_id",       null: false
    t.integer  "user_id",        null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "proposition_id"
  end

  add_index "comments", ["issue_id"], name: "index_comments_on_issue_id"
  add_index "comments", ["proposition_id"], name: "index_comments_on_proposition_id"
  add_index "comments", ["user_id"], name: "index_comments_on_user_id"

  create_table "issues", force: :cascade do |t|
    t.string   "title",                  null: false
    t.integer  "user_id",                null: false
    t.datetime "created_at",             null: false
    t.datetime "updated_at",             null: false
    t.integer  "related_proposition_id"
    t.integer  "parent_issue_id"
  end

  add_index "issues", ["parent_issue_id"], name: "index_issues_on_parent_issue_id"
  add_index "issues", ["related_proposition_id"], name: "index_issues_on_related_proposition_id"
  add_index "issues", ["user_id"], name: "index_issues_on_user_id"

  create_table "links", force: :cascade do |t|
    t.string   "url",         null: false
    t.text     "title"
    t.text     "description"
    t.text     "image"
    t.datetime "created_at",  null: false
    t.datetime "updated_at",  null: false
  end

  add_index "links", ["url"], name: "index_links_on_url"

  create_table "propositions", force: :cascade do |t|
    t.string   "title",                    null: false
    t.integer  "issue_id",                 null: false
    t.integer  "user_id",                  null: false
    t.datetime "created_at",               null: false
    t.datetime "updated_at",               null: false
    t.integer  "stands_count", default: 0, null: false
  end

  add_index "propositions", ["issue_id"], name: "index_propositions_on_issue_id"
  add_index "propositions", ["user_id"], name: "index_propositions_on_user_id"

  create_table "related_links", force: :cascade do |t|
    t.integer "issue_id",       null: false
    t.integer "link_id",        null: false
    t.integer "source_id",      null: false
    t.string  "source_type",    null: false
    t.integer "proposition_id"
  end

  add_index "related_links", ["issue_id"], name: "index_related_links_on_issue_id"
  add_index "related_links", ["link_id"], name: "index_related_links_on_link_id"
  add_index "related_links", ["proposition_id"], name: "index_related_links_on_proposition_id"
  add_index "related_links", ["source_id", "link_id"], name: "index_related_links_on_source_id_and_link_id", unique: true
  add_index "related_links", ["source_type", "source_id"], name: "index_related_links_on_source_type_and_source_id"

  create_table "replies", force: :cascade do |t|
    t.text     "contents",   null: false
    t.integer  "status_id",  null: false
    t.integer  "user_id",    null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "replies", ["status_id"], name: "index_replies_on_status_id"
  add_index "replies", ["user_id"], name: "index_replies_on_user_id"

  create_table "stands", force: :cascade do |t|
    t.integer  "choice",                        null: false
    t.boolean  "current",        default: true
    t.integer  "previous_id"
    t.integer  "proposition_id",                null: false
    t.integer  "user_id",                       null: false
    t.datetime "created_at",                    null: false
    t.datetime "updated_at",                    null: false
    t.text     "description"
  end

  add_index "stands", ["proposition_id"], name: "index_stands_on_proposition_id"
  add_index "stands", ["user_id"], name: "index_stands_on_user_id"

  create_table "statuses", force: :cascade do |t|
    t.integer  "issue_id",       null: false
    t.integer  "source_id",      null: false
    t.string   "source_type",    null: false
    t.datetime "created_at",     null: false
    t.datetime "updated_at",     null: false
    t.integer  "proposition_id"
  end

  add_index "statuses", ["issue_id"], name: "index_statuses_on_issue_id"
  add_index "statuses", ["proposition_id"], name: "index_statuses_on_proposition_id"
  add_index "statuses", ["source_type", "source_id"], name: "index_statuses_on_source_type_and_source_id"

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
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
  end

  add_index "users", ["email"], name: "index_users_on_email", unique: true
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true

end
