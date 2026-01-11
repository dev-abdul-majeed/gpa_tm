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

ActiveRecord::Schema[8.0].define(version: 2026_01_08_203400) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "assignment_group_scores", force: :cascade do |t|
    t.bigint "assignment_id", null: false
    t.bigint "group_id"
    t.decimal "group_score", precision: 5, scale: 2, null: false
    t.datetime "set_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignment_id", "group_id"], name: "idx_ags_on_assignment_and_group", unique: true
    t.index ["assignment_id"], name: "idx_ags_on_assignment_id"
    t.index ["assignment_id"], name: "index_assignment_group_scores_on_assignment_id"
    t.index ["group_id"], name: "index_assignment_group_scores_on_group_id"
  end

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
    t.integer "lower_bound", default: 1
    t.integer "upper_bound", default: 7
    t.float "border_size", default: 0.003
    t.float "polarity_factor", default: 1.0
    t.float "group_spread", default: 0.5
    t.float "group_score", default: 0.8, null: false
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

  create_table "final_marks", force: :cascade do |t|
    t.bigint "student_id", null: false
    t.bigint "assignment_id", null: false
    t.bigint "group_id", null: false
    t.bigint "assignment_group_score_id", null: false
    t.decimal "score", precision: 5, scale: 2, null: false
    t.datetime "calculated_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignment_group_score_id"], name: "idx_fm_on_ags_id"
    t.index ["assignment_group_score_id"], name: "index_final_marks_on_assignment_group_score_id"
    t.index ["assignment_id"], name: "idx_fm_on_assignment_id"
    t.index ["assignment_id"], name: "index_final_marks_on_assignment_id"
    t.index ["group_id"], name: "idx_fm_on_group_id"
    t.index ["group_id"], name: "index_final_marks_on_group_id"
    t.index ["student_id", "assignment_id"], name: "idx_fm_on_student_and_assignment", unique: true
    t.index ["student_id"], name: "index_final_marks_on_student_id"
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

  create_table "peer_mark_submissions", force: :cascade do |t|
    t.bigint "assignment_id", null: false
    t.bigint "giver_id", null: false
    t.boolean "submitted", default: false, null: false
    t.datetime "submitted_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignment_id", "giver_id"], name: "index_peer_mark_submissions_on_assignment_and_giver", unique: true
    t.index ["assignment_id"], name: "index_peer_mark_submissions_on_assignment_id"
    t.index ["giver_id"], name: "index_peer_mark_submissions_on_giver_id"
  end

  create_table "peer_marks", force: :cascade do |t|
    t.bigint "assignment_id", null: false
    t.bigint "group_id", null: false
    t.bigint "giver_id", null: false
    t.bigint "receiver_id", null: false
    t.float "score", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["assignment_id", "giver_id", "receiver_id"], name: "index_peer_marks_on_assignment_giver_receiver", unique: true
    t.index ["assignment_id"], name: "index_peer_marks_on_assignment_id"
    t.index ["giver_id"], name: "index_peer_marks_on_giver_id"
    t.index ["group_id"], name: "index_peer_marks_on_group_id"
    t.index ["receiver_id"], name: "index_peer_marks_on_receiver_id"
    t.check_constraint "score >= 0::double precision AND score <= 100::double precision", name: "peer_marks_score_range"
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

  add_foreign_key "assignment_group_scores", "assignments"
  add_foreign_key "assignment_group_scores", "groups"
  add_foreign_key "assignments", "courses"
  add_foreign_key "course_students", "courses"
  add_foreign_key "course_students", "users", column: "student_id"
  add_foreign_key "courses", "users", column: "teacher_id"
  add_foreign_key "final_marks", "assignment_group_scores"
  add_foreign_key "final_marks", "assignments"
  add_foreign_key "final_marks", "groups"
  add_foreign_key "final_marks", "users", column: "student_id"
  add_foreign_key "group_memberships", "groups"
  add_foreign_key "group_memberships", "users", column: "student_id"
  add_foreign_key "groups", "courses"
  add_foreign_key "peer_mark_submissions", "assignments"
  add_foreign_key "peer_mark_submissions", "users", column: "giver_id"
  add_foreign_key "peer_marks", "assignments"
  add_foreign_key "peer_marks", "groups"
  add_foreign_key "peer_marks", "users", column: "giver_id"
  add_foreign_key "peer_marks", "users", column: "receiver_id"
  add_foreign_key "users", "schools"
end
