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

ActiveRecord::Schema.define(version: 20150211233315) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "courses", force: :cascade do |t|
    t.string   "department"
    t.integer  "course_number"
    t.text     "description"
    t.string   "course_offering"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  add_index "courses", ["course_number"], name: "index_courses_on_course_number", using: :btree
  add_index "courses", ["department", "course_number"], name: "index_courses_on_department_and_course_number", using: :btree
  add_index "courses", ["department"], name: "index_courses_on_department", using: :btree

end
