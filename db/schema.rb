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

ActiveRecord::Schema.define(version: 20141202183854) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "activities", force: true do |t|
    t.string   "name"
    t.string   "date"
    t.integer  "event_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["event_id"], name: "index_activities_on_event_id", using: :btree

  create_table "authorizations", force: true do |t|
    t.integer  "user_id"
    t.string   "provider"
    t.string   "uid"
    t.string   "instance_url"
    t.string   "oauth_token"
    t.string   "refresh_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "authorizations", ["user_id"], name: "index_authorizations_on_user_id", using: :btree

  create_table "events", force: true do |t|
    t.string   "name"
    t.string   "date"
    t.string   "recurrence"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "shifts", force: true do |t|
    t.string   "sf_contact_id"
    t.string   "sf_volunteer_shift_id"
    t.integer  "volunteer_id"
    t.integer  "activity_id"
    t.string   "date"
    t.decimal  "hours",                 precision: 12, scale: 2
    t.string   "status",                                         default: "Sign Up"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "shift_name"
    t.string   "year"
    t.string   "shift_type"
  end

  add_index "shifts", ["activity_id"], name: "index_shifts_on_activity_id", using: :btree
  add_index "shifts", ["volunteer_id"], name: "index_shifts_on_volunteer_id", using: :btree

  create_table "syncers", force: true do |t|
    t.string   "last_sync",      default: "1000-01-01T00:00:00Z"
    t.string   "last_full_sync", default: "1000-01-01T00:00:00Z"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", force: true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "volunteers", force: true do |t|
    t.string   "sf_contact_id"
    t.string   "name_first"
    t.string   "name_last"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
