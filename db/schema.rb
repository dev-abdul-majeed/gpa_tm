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

ActiveRecord::Schema[8.0].define(version: 2025_08_13_001452) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "assignments", force: :cascade do |t|
    t.string "title", limit: 50, null: false
    t.string "assignment_type", null: false
    t.integer "rating_scale", default: 0, null: false
    t.string "rating_model", default: "B"
    t.boolean "calibration", default: false
    t.datetime "start_date_time"
    t.datetime "end_date_time"
    t.decimal "self_rating_weight", precision: 5, scale: 2, default: "0.0"
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignment_type"], name: "index_assignments_on_assignment_type"
    t.index ["calibration"], name: "index_assignments_on_calibration"
    t.index ["course_id"], name: "index_assignments_on_course_id"
    t.index ["rating_scale"], name: "index_assignments_on_rating_scale"
  end

  create_table "course_students", id: false, force: :cascade do |t|
    t.bigint "course_id"
    t.bigint "student_id"
    t.index ["course_id"], name: "index_course_students_on_course_id"
    t.index ["student_id"], name: "index_course_students_on_student_id"
  end

  create_table "courses", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.bigint "teacher_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["teacher_id", "name"], name: "index_courses_on_teacher_id_and_name", unique: true
    t.index ["teacher_id"], name: "index_courses_on_teacher_id"
  end

  create_table "group_memberships", force: :cascade do |t|
    t.bigint "group_id", null: false
    t.bigint "student_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["group_id"], name: "index_group_memberships_on_group_id"
    t.index ["student_id", "group_id"], name: "index_group_memberships_on_student_id_and_group_id", unique: true
    t.index ["student_id"], name: "index_group_memberships_on_student_id"
  end

  create_table "groups", force: :cascade do |t|
    t.string "group_name", null: false
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id", "group_name"], name: "index_groups_on_course_id_and_group_name", unique: true
    t.index ["course_id"], name: "index_groups_on_course_id"
  end

  create_table "schools", force: :cascade do |t|
    t.string "name"
    t.string "location"
    t.string "domain"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email", limit: 150, default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.string "first_name", limit: 50, null: false
    t.string "last_name", limit: 50, null: false
    t.string "gender", limit: 10, null: false
    t.date "date_of_birth", null: false
    t.string "type", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "school_id"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["school_id"], name: "index_users_on_school_id"
    t.index ["type", "email"], name: "index_users_on_type_and_email"
  end

  add_foreign_key "assignments", "courses"
  add_foreign_key "course_students", "courses"
  add_foreign_key "course_students", "users", column: "student_id"
  add_foreign_key "courses", "users", column: "teacher_id"
  add_foreign_key "group_memberships", "groups"
  add_foreign_key "group_memberships", "users", column: "student_id"
  add_foreign_key "groups", "courses"
  add_foreign_key "users", "schools"
end
