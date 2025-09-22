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

ActiveRecord::Schema[8.1].define(version: 2025_09_22_072322) do
  create_table "lms_courses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.string "subtitle"
    t.string "title"
    t.datetime "updated_at", null: false
  end

  create_table "lms_curriculum_items", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.integer "section_id", null: false
    t.string "title"
    t.datetime "updated_at", null: false
    t.index ["section_id"], name: "index_lms_curriculum_items_on_section_id"
  end

  create_table "lms_sections", force: :cascade do |t|
    t.integer "course_id", null: false
    t.datetime "created_at", null: false
    t.string "name"
    t.datetime "updated_at", null: false
    t.index ["course_id"], name: "index_lms_sections_on_course_id"
  end

  add_foreign_key "lms_curriculum_items", "sections"
  add_foreign_key "lms_sections", "courses"
end
