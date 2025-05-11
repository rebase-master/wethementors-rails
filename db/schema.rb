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

ActiveRecord::Schema[7.2].define(version: 2024_03_21_000030) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "jwt_denylist", force: :cascade do |t|
    t.string "jti", null: false
    t.datetime "exp", null: false
    t.index ["jti"], name: "index_jwt_denylist_on_jti"
  end

  create_table "milestone_completions", force: :cascade do |t|
    t.bigint "milestone_id", null: false
    t.bigint "user_id", null: false
    t.boolean "completed", default: false
    t.datetime "started_at"
    t.datetime "completed_at"
    t.text "notes"
    t.jsonb "submission_data", default: {}
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["completed"], name: "index_milestone_completions_on_completed"
    t.index ["milestone_id", "user_id"], name: "index_milestone_completions_on_milestone_id_and_user_id", unique: true
    t.index ["milestone_id"], name: "index_milestone_completions_on_milestone_id"
    t.index ["user_id"], name: "index_milestone_completions_on_user_id"
  end

  create_table "milestones", force: :cascade do |t|
    t.bigint "program_section_id", null: false
    t.string "title", null: false
    t.text "description", null: false
    t.integer "order", null: false
    t.string "milestone_type", null: false
    t.integer "estimated_duration"
    t.boolean "required", default: true
    t.jsonb "content", default: {}
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["milestone_type"], name: "index_milestones_on_milestone_type"
    t.index ["program_section_id", "order"], name: "index_milestones_on_program_section_id_and_order"
    t.index ["program_section_id"], name: "index_milestones_on_program_section_id"
  end

  create_table "notifications", force: :cascade do |t|
    t.string "recipient_type", null: false
    t.bigint "recipient_id", null: false
    t.string "actor_type"
    t.bigint "actor_id"
    t.string "type", null: false
    t.jsonb "data", default: {}
    t.datetime "read_at"
    t.boolean "email_sent", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["actor_type", "actor_id"], name: "index_notifications_on_actor"
    t.index ["actor_type", "actor_id"], name: "index_notifications_on_actor_type_and_actor_id"
    t.index ["email_sent"], name: "index_notifications_on_email_sent"
    t.index ["read_at"], name: "index_notifications_on_read_at"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient"
    t.index ["recipient_type", "recipient_id"], name: "index_notifications_on_recipient_type_and_recipient_id"
    t.index ["type"], name: "index_notifications_on_type"
  end

  create_table "profile_options", force: :cascade do |t|
    t.string "name", null: false
    t.string "options", null: false
    t.text "description"
    t.boolean "required", default: false
    t.boolean "public", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_profile_options_on_name", unique: true
    t.index ["options"], name: "index_profile_options_on_options", unique: true
  end

  create_table "program_certificates", force: :cascade do |t|
    t.bigint "program_id", null: false
    t.bigint "user_id", null: false
    t.string "certificate_number", null: false
    t.datetime "issued_at", null: false
    t.datetime "expires_at"
    t.string "status", default: "active", null: false
    t.string "verification_code", null: false
    t.jsonb "metadata", default: {}
    t.jsonb "achievement_data", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["certificate_number"], name: "index_program_certificates_on_certificate_number", unique: true
    t.index ["program_id", "user_id"], name: "index_program_certificates_on_program_id_and_user_id", unique: true
    t.index ["program_id"], name: "index_program_certificates_on_program_id"
    t.index ["status"], name: "index_program_certificates_on_status"
    t.index ["user_id"], name: "index_program_certificates_on_user_id"
    t.index ["verification_code"], name: "index_program_certificates_on_verification_code", unique: true
  end

  create_table "program_comments", force: :cascade do |t|
    t.bigint "program_id", null: false
    t.bigint "user_id", null: false
    t.text "comment", null: false
    t.boolean "deleted", default: false
    t.boolean "flagged", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_program_comments_on_created_at"
    t.index ["deleted"], name: "index_program_comments_on_deleted"
    t.index ["flagged"], name: "index_program_comments_on_flagged"
    t.index ["program_id"], name: "index_program_comments_on_program_id"
    t.index ["user_id"], name: "index_program_comments_on_user_id"
  end

  create_table "program_enrollments", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "program_id", null: false
    t.string "status", null: false
    t.integer "progress", default: 0
    t.datetime "started_at", null: false
    t.datetime "completed_at"
    t.datetime "dropped_at"
    t.text "notes"
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_id"], name: "index_program_enrollments_on_program_id"
    t.index ["progress"], name: "index_program_enrollments_on_progress"
    t.index ["status"], name: "index_program_enrollments_on_status"
    t.index ["user_id", "program_id"], name: "index_program_enrollments_on_user_id_and_program_id", unique: true
    t.index ["user_id"], name: "index_program_enrollments_on_user_id"
  end

  create_table "program_prerequisites", force: :cascade do |t|
    t.bigint "program_id", null: false
    t.bigint "prerequisite_program_id", null: false
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["prerequisite_program_id"], name: "index_program_prerequisites_on_prerequisite_program_id"
    t.index ["program_id", "prerequisite_program_id"], name: "index_program_prerequisites_on_program_and_prereq", unique: true
    t.index ["program_id"], name: "index_program_prerequisites_on_program_id"
  end

  create_table "program_ratings", force: :cascade do |t|
    t.bigint "program_id", null: false
    t.bigint "user_id", null: false
    t.integer "rating", null: false
    t.text "review"
    t.boolean "verified_completion", default: false
    t.boolean "helpful_votes_count", default: false
    t.boolean "unhelpful_votes_count", default: false
    t.boolean "flagged", default: false
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["flagged"], name: "index_program_ratings_on_flagged"
    t.index ["program_id", "user_id"], name: "index_program_ratings_on_program_id_and_user_id", unique: true
    t.index ["program_id"], name: "index_program_ratings_on_program_id"
    t.index ["rating"], name: "index_program_ratings_on_rating"
    t.index ["user_id"], name: "index_program_ratings_on_user_id"
    t.index ["verified_completion"], name: "index_program_ratings_on_verified_completion"
  end

  create_table "program_sections", force: :cascade do |t|
    t.bigint "program_id", null: false
    t.string "title", null: false
    t.text "description"
    t.integer "order", null: false
    t.boolean "required", default: true
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_id", "order"], name: "index_program_sections_on_program_id_and_order"
    t.index ["program_id"], name: "index_program_sections_on_program_id"
  end

  create_table "programs", force: :cascade do |t|
    t.bigint "topic_id", null: false
    t.string "heading"
    t.string "slug", null: false
    t.text "question", null: false
    t.text "solution", null: false
    t.boolean "visible", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "difficulty_level"
    t.integer "estimated_duration", comment: "Duration in minutes"
    t.text "description"
    t.text "learning_objectives"
    t.jsonb "resources", default: {}
    t.jsonb "metadata", default: {}
    t.index ["created_at"], name: "index_programs_on_created_at"
    t.index ["difficulty_level"], name: "index_programs_on_difficulty_level"
    t.index ["estimated_duration"], name: "index_programs_on_estimated_duration"
    t.index ["slug"], name: "index_programs_on_slug", unique: true
    t.index ["topic_id"], name: "index_programs_on_topic_id"
    t.index ["visible"], name: "index_programs_on_visible"
  end

  create_table "qa_answers", force: :cascade do |t|
    t.bigint "qa_question_id", null: false
    t.bigint "user_id", null: false
    t.text "answer", null: false
    t.boolean "visible", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_qa_answers_on_created_at"
    t.index ["qa_question_id"], name: "index_qa_answers_on_qa_question_id"
    t.index ["user_id"], name: "index_qa_answers_on_user_id"
    t.index ["visible"], name: "index_qa_answers_on_visible"
  end

  create_table "qa_questions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "topic"
    t.string "tags"
    t.text "question", null: false
    t.text "description"
    t.boolean "visible", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["created_at"], name: "index_qa_questions_on_created_at"
    t.index ["topic"], name: "index_qa_questions_on_topic"
    t.index ["user_id"], name: "index_qa_questions_on_user_id"
    t.index ["visible"], name: "index_qa_questions_on_visible"
  end

  create_table "qa_votes", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "votable_type", null: false
    t.bigint "votable_id", null: false
    t.integer "vote", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id", "votable_type", "votable_id"], name: "index_qa_votes_on_user_id_and_votable_type_and_votable_id", unique: true
    t.index ["user_id"], name: "index_qa_votes_on_user_id"
    t.index ["votable_type", "votable_id"], name: "index_qa_votes_on_votable"
    t.index ["votable_type", "votable_id"], name: "index_qa_votes_on_votable_type_and_votable_id"
  end

  create_table "quiz_categories", force: :cascade do |t|
    t.string "category", null: false
    t.text "description"
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_quiz_categories_on_active"
    t.index ["category"], name: "index_quiz_categories_on_category", unique: true
  end

  create_table "quiz_progresses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "quiz_category_id", null: false
    t.integer "completed_questions", default: 0
    t.integer "correct_answers", default: 0
    t.integer "total_attempts", default: 0
    t.decimal "average_score", precision: 5, scale: 2, default: "0.0"
    t.datetime "last_attempt_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_category_id"], name: "index_quiz_progresses_on_quiz_category_id"
    t.index ["user_id", "quiz_category_id"], name: "index_quiz_progresses_on_user_id_and_quiz_category_id", unique: true
    t.index ["user_id"], name: "index_quiz_progresses_on_user_id"
  end

  create_table "quiz_questions", force: :cascade do |t|
    t.bigint "quiz_category_id", null: false
    t.text "question", null: false
    t.text "options", default: [], array: true
    t.integer "correct_option", null: false
    t.text "explanation"
    t.integer "difficulty", default: 1
    t.boolean "active", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["active"], name: "index_quiz_questions_on_active"
    t.index ["difficulty"], name: "index_quiz_questions_on_difficulty"
    t.index ["quiz_category_id"], name: "index_quiz_questions_on_quiz_category_id"
  end

  create_table "quiz_scores", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "quiz_category_id", null: false
    t.integer "score", null: false
    t.integer "total_questions", null: false
    t.integer "correct_answers", null: false
    t.integer "time_taken", comment: "Time taken in seconds"
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_category_id"], name: "index_quiz_scores_on_quiz_category_id"
    t.index ["score"], name: "index_quiz_scores_on_score"
    t.index ["user_id", "quiz_category_id"], name: "index_quiz_scores_on_user_id_and_quiz_category_id"
    t.index ["user_id"], name: "index_quiz_scores_on_user_id"
  end

  create_table "rating_votes", force: :cascade do |t|
    t.bigint "program_rating_id", null: false
    t.bigint "user_id", null: false
    t.boolean "helpful", null: false
    t.jsonb "metadata", default: {}
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["helpful"], name: "index_rating_votes_on_helpful"
    t.index ["program_rating_id", "user_id"], name: "index_rating_votes_on_program_rating_id_and_user_id", unique: true
    t.index ["program_rating_id"], name: "index_rating_votes_on_program_rating_id"
    t.index ["user_id"], name: "index_rating_votes_on_user_id"
  end

  create_table "section_completions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "program_section_id", null: false
    t.boolean "completed", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["completed"], name: "index_section_completions_on_completed"
    t.index ["program_section_id"], name: "index_section_completions_on_program_section_id"
    t.index ["user_id", "program_section_id"], name: "index_section_completions_on_user_id_and_program_section_id", unique: true
    t.index ["user_id"], name: "index_section_completions_on_user_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name", null: false
    t.string "url_name", null: false
    t.boolean "visible", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_subjects_on_name", unique: true
    t.index ["url_name"], name: "index_subjects_on_url_name", unique: true
    t.index ["visible"], name: "index_subjects_on_visible"
  end

  create_table "taggings", force: :cascade do |t|
    t.bigint "tag_id", null: false
    t.string "taggable_type", null: false
    t.bigint "taggable_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["tag_id", "taggable_type", "taggable_id"], name: "index_taggings_on_tag_and_taggable", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable"
    t.index ["taggable_type", "taggable_id"], name: "index_taggings_on_taggable_type_and_taggable_id"
  end

  create_table "tags", force: :cascade do |t|
    t.string "name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "topics", force: :cascade do |t|
    t.string "name", null: false
    t.string "url_name", null: false
    t.boolean "visible", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["name"], name: "index_topics_on_name", unique: true
    t.index ["url_name"], name: "index_topics_on_url_name", unique: true
    t.index ["visible"], name: "index_topics_on_visible"
  end

  create_table "user_data", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "profile_option_id", null: false
    t.text "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["profile_option_id"], name: "index_user_data_on_profile_option_id"
    t.index ["user_id", "profile_option_id"], name: "index_user_data_on_user_id_and_profile_option_id", unique: true
    t.index ["user_id"], name: "index_user_data_on_user_id"
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.boolean "admin", default: false
    t.string "type"
    t.string "access_token"
    t.string "password_digest", null: false
    t.string "registration_key"
    t.boolean "confirmed", default: false
    t.string "username", null: false
    t.string "first_name"
    t.string "last_name"
    t.string "gender"
    t.datetime "last_login"
    t.boolean "blocked", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["access_token"], name: "index_users_on_access_token"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["registration_key"], name: "index_users_on_registration_key"
    t.index ["username"], name: "index_users_on_username", unique: true
  end

  create_table "yearly_questions", force: :cascade do |t|
    t.integer "year", null: false
    t.string "subject", null: false
    t.string "type", null: false
    t.integer "position"
    t.string "slug", null: false
    t.string "heading"
    t.text "question", null: false
    t.text "solution", null: false
    t.boolean "visible", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_yearly_questions_on_slug", unique: true
    t.index ["subject"], name: "index_yearly_questions_on_subject"
    t.index ["type"], name: "index_yearly_questions_on_type"
    t.index ["visible"], name: "index_yearly_questions_on_visible"
    t.index ["year", "subject", "type"], name: "index_yearly_questions_on_year_and_subject_and_type"
    t.index ["year"], name: "index_yearly_questions_on_year"
  end

  add_foreign_key "milestone_completions", "milestones"
  add_foreign_key "milestone_completions", "users"
  add_foreign_key "milestones", "program_sections"
  add_foreign_key "program_certificates", "programs"
  add_foreign_key "program_certificates", "users"
  add_foreign_key "program_comments", "programs"
  add_foreign_key "program_comments", "users"
  add_foreign_key "program_enrollments", "programs"
  add_foreign_key "program_enrollments", "users"
  add_foreign_key "program_prerequisites", "programs"
  add_foreign_key "program_prerequisites", "programs", column: "prerequisite_program_id"
  add_foreign_key "program_ratings", "programs"
  add_foreign_key "program_ratings", "users"
  add_foreign_key "program_sections", "programs"
  add_foreign_key "programs", "topics"
  add_foreign_key "qa_answers", "qa_questions"
  add_foreign_key "qa_answers", "users"
  add_foreign_key "qa_questions", "users"
  add_foreign_key "qa_votes", "users"
  add_foreign_key "quiz_progresses", "quiz_categories"
  add_foreign_key "quiz_progresses", "users"
  add_foreign_key "quiz_questions", "quiz_categories"
  add_foreign_key "quiz_scores", "quiz_categories"
  add_foreign_key "quiz_scores", "users"
  add_foreign_key "rating_votes", "program_ratings"
  add_foreign_key "rating_votes", "users"
  add_foreign_key "section_completions", "program_sections"
  add_foreign_key "section_completions", "users"
  add_foreign_key "taggings", "tags"
  add_foreign_key "user_data", "profile_options"
  add_foreign_key "user_data", "users"
end
