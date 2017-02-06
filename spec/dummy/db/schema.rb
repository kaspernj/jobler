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

ActiveRecord::Schema.define(version: 20170206104246) do

  create_table "jobler_jobs", force: :cascade do |t|
    t.string   "jobler_type",                     null: false
    t.string   "state",           default: "new", null: false
    t.float    "progress",        default: 0.0,   null: false
    t.text     "parameters"
    t.datetime "started_at"
    t.datetime "ended_at"
    t.datetime "created_at",                      null: false
    t.datetime "updated_at",                      null: false
    t.string   "locale"
    t.text     "error_message"
    t.string   "error_type"
    t.text     "error_backtrace"
    t.string   "slug"
  end

  add_index "jobler_jobs", ["slug"], name: "index_jobler_jobs_on_slug", unique: true

  create_table "jobler_results", force: :cascade do |t|
    t.integer  "job_id",     null: false
    t.string   "name",       null: false
    t.binary   "result"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "jobler_results", ["job_id"], name: "index_jobler_results_on_job_id"
  add_index "jobler_results", ["name"], name: "index_jobler_results_on_name"

end
