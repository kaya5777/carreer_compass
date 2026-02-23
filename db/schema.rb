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

ActiveRecord::Schema[8.0].define(version: 2026_02_12_234816) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "ai_messages", force: :cascade do |t|
    t.bigint "ai_session_id", null: false
    t.integer "role", default: 0
    t.text "content"
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ai_session_id"], name: "index_ai_messages_on_ai_session_id"
  end

  create_table "ai_sessions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "sessionable_type"
    t.integer "sessionable_id"
    t.integer "session_type", default: 0
    t.string "title"
    t.text "system_prompt"
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["sessionable_type", "sessionable_id"], name: "index_ai_sessions_on_sessionable_type_and_sessionable_id"
    t.index ["user_id"], name: "index_ai_sessions_on_user_id"
  end

  create_table "interview_preps", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "resume_id"
    t.string "company_name"
    t.text "job_posting"
    t.text "company_info"
    t.integer "interview_type"
    t.integer "status"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["resume_id"], name: "index_interview_preps_on_resume_id"
    t.index ["user_id"], name: "index_interview_preps_on_user_id"
  end

  create_table "interview_questions", force: :cascade do |t|
    t.bigint "interview_prep_id", null: false
    t.text "question_text"
    t.text "suggested_answer"
    t.integer "category"
    t.integer "difficulty"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["interview_prep_id"], name: "index_interview_questions_on_interview_prep_id"
  end

  create_table "mock_answers", force: :cascade do |t|
    t.bigint "interview_question_id", null: false
    t.bigint "ai_session_id", null: false
    t.text "user_answer"
    t.text "ai_feedback"
    t.integer "score"
    t.jsonb "evaluation_details", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["ai_session_id"], name: "index_mock_answers_on_ai_session_id"
    t.index ["interview_question_id"], name: "index_mock_answers_on_interview_question_id"
  end

  create_table "resumes", force: :cascade do |t|
    t.string "title"
    t.text "personal_summary"
    t.text "work_history"
    t.text "skills"
    t.text "self_promotion"
    t.text "raw_content"
    t.string "target_industry"
    t.string "target_role"
    t.integer "status", default: 0
    t.bigint "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_resumes_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.string "display_name"
    t.integer "career_stage", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
  end

  add_foreign_key "ai_messages", "ai_sessions"
  add_foreign_key "ai_sessions", "users"
  add_foreign_key "interview_preps", "resumes"
  add_foreign_key "interview_preps", "users"
  add_foreign_key "interview_questions", "interview_preps"
  add_foreign_key "mock_answers", "ai_sessions"
  add_foreign_key "mock_answers", "interview_questions"
  add_foreign_key "resumes", "users"
end
