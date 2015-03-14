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

ActiveRecord::Schema.define(version: 20150314025511) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "course_instances", force: :cascade do |t|
    t.integer "semester_id"
    t.integer "course_id"
    t.integer "professor_id"
    t.date    "start_date"
    t.date    "end_date"
    t.integer "section"
    t.string  "component_code"
    t.string  "subtitle"
  end

  add_index "course_instances", ["course_id"], name: "index_course_instances_on_course_id", using: :btree
  add_index "course_instances", ["professor_id"], name: "index_course_instances_on_professor_id", using: :btree
  add_index "course_instances", ["semester_id"], name: "index_course_instances_on_semester_id", using: :btree

  create_table "courses", force: :cascade do |t|
    t.string   "department"
    t.integer  "course_number"
    t.text     "description"
    t.string   "course_offering"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
    t.string   "title"
  end

  add_index "courses", ["course_number"], name: "index_courses_on_course_number", using: :btree
  add_index "courses", ["department", "course_number"], name: "index_courses_on_department_and_course_number", using: :btree
  add_index "courses", ["department"], name: "index_courses_on_department", using: :btree

  create_table "meetings", force: :cascade do |t|
    t.integer  "course_instance_id"
    t.integer  "professor_id"
    t.string   "schedule"
    t.string   "room"
    t.date     "start_date"
    t.date     "end_date"
    t.datetime "created_at",         null: false
    t.datetime "updated_at",         null: false
  end

  add_index "meetings", ["course_instance_id"], name: "index_meetings_on_course_instance_id", using: :btree
  add_index "meetings", ["professor_id"], name: "index_meetings_on_professor_id", using: :btree

  create_table "prerequisites", id: false, force: :cascade do |t|
    t.integer "postrequisite_id",                 null: false
    t.integer "prerequisite_ids", default: [],                 array: true
    t.boolean "co_req",           default: false
  end

  create_table "professors", force: :cascade do |t|
    t.string   "name"
    t.string   "department"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "semesters", force: :cascade do |t|
    t.integer "year"
    t.string  "semester"
    t.boolean "finished"
  end

  create_table "users", force: :cascade do |t|
    t.string   "case_id"
    t.string   "name"
    t.string   "type"
    t.integer  "class_year"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_index "users", ["case_id"], name: "index_users_on_case_id", using: :btree

  create_table "wishlist_items", force: :cascade do |t|
    t.integer "user_id"
    t.integer "course_id"
  end

  add_foreign_key "course_instances", "courses"
  add_foreign_key "course_instances", "professors"
  add_foreign_key "course_instances", "semesters"
  add_foreign_key "meetings", "course_instances"
  add_foreign_key "meetings", "professors"
end
