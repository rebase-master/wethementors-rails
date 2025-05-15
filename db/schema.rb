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

ActiveRecord::Schema[7.2].define(version: 2025_05_15_042532) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "notes", force: :cascade do |t|
    t.bigint "notes_category_id", null: false
    t.bigint "notes_sub_category_id", null: false
    t.string "slug", null: false
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notes_category_id"], name: "index_notes_on_notes_category_id"
    t.index ["notes_sub_category_id"], name: "index_notes_on_notes_sub_category_id"
    t.index ["slug"], name: "index_notes_on_slug", unique: true
  end

  create_table "notes_categories", force: :cascade do |t|
    t.string "category"
    t.string "type"
    t.boolean "visible"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "notes_contents", force: :cascade do |t|
    t.bigint "note_id", null: false
    t.string "heading", null: false
    t.string "slug", null: false
    t.string "cover_image"
    t.text "content", null: false
    t.string "extract"
    t.string "source"
    t.boolean "deleted", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["note_id"], name: "index_notes_contents_on_note_id"
    t.index ["slug"], name: "index_notes_contents_on_slug", unique: true
  end

  create_table "notes_sub_categories", force: :cascade do |t|
    t.bigint "notes_category_id", null: false
    t.string "sub_category"
    t.boolean "visible"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["notes_category_id"], name: "index_notes_sub_categories_on_notes_category_id"
  end

  create_table "program_comments", force: :cascade do |t|
    t.bigint "program_id", null: false
    t.bigint "user_id", null: false
    t.text "comment", null: false
    t.boolean "deleted", default: false
    t.boolean "flagged", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["program_id"], name: "index_program_comments_on_program_id"
    t.index ["user_id"], name: "index_program_comments_on_user_id"
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
    t.index ["slug"], name: "index_programs_on_slug", unique: true
    t.index ["topic_id"], name: "index_programs_on_topic_id"
  end

  create_table "qa_answer_votes", force: :cascade do |t|
    t.bigint "qa_answer_id", null: false
    t.bigint "user_id", null: false
    t.integer "vote", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["qa_answer_id"], name: "index_qa_answer_votes_on_qa_answer_id"
    t.index ["user_id"], name: "index_qa_answer_votes_on_user_id"
  end

  create_table "qa_answers", force: :cascade do |t|
    t.bigint "qa_question_id", null: false
    t.bigint "user_id", null: false
    t.text "answer", null: false
    t.boolean "visible", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["qa_question_id"], name: "index_qa_answers_on_qa_question_id"
    t.index ["user_id"], name: "index_qa_answers_on_user_id"
  end

  create_table "qa_question_votes", force: :cascade do |t|
    t.bigint "qa_question_id", null: false
    t.bigint "user_id", null: false
    t.integer "vote", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["qa_question_id"], name: "index_qa_question_votes_on_qa_question_id"
    t.index ["user_id"], name: "index_qa_question_votes_on_user_id"
  end

  create_table "qa_questions", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.string "question", null: false
    t.text "description"
    t.boolean "visible", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_qa_questions_on_user_id"
  end

  create_table "quiz_categories", force: :cascade do |t|
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "quiz_options", force: :cascade do |t|
    t.bigint "quiz_question_id", null: false
    t.string "option_text", null: false
    t.boolean "correct", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_question_id"], name: "index_quiz_options_on_quiz_question_id"
  end

  create_table "quiz_questions", force: :cascade do |t|
    t.bigint "quiz_category_id", null: false
    t.string "question", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_category_id"], name: "index_quiz_questions_on_quiz_category_id"
  end

  create_table "quiz_scores", force: :cascade do |t|
    t.bigint "quiz_category_id", null: false
    t.bigint "user_id", null: false
    t.integer "score"
    t.integer "attempts"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_category_id"], name: "index_quiz_scores_on_quiz_category_id"
    t.index ["user_id"], name: "index_quiz_scores_on_user_id"
  end

  create_table "subjects", force: :cascade do |t|
    t.string "name", null: false
    t.string "url_name", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url_name"], name: "index_subjects_on_url_name", unique: true
  end

  create_table "topics", force: :cascade do |t|
    t.string "topic", null: false
    t.string "url_name", null: false
    t.boolean "visible", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["url_name"], name: "index_topics_on_url_name", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "password_digest"
    t.string "name"
    t.string "role"
    t.string "status"
    t.datetime "last_login"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "votes", force: :cascade do |t|
    t.string "votable_type", null: false
    t.bigint "votable_id", null: false
    t.bigint "user_id", null: false
    t.integer "vote", default: 0, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_votes_on_user_id"
    t.index ["votable_type", "votable_id"], name: "index_votes_on_votable"
  end

  create_table "yearly_question_comments", force: :cascade do |t|
    t.bigint "yearly_question_id", null: false
    t.bigint "user_id", null: false
    t.text "comment", null: false
    t.boolean "deleted", default: false
    t.boolean "flagged", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_yearly_question_comments_on_user_id"
    t.index ["yearly_question_id"], name: "index_yearly_question_comments_on_yearly_question_id"
  end

  create_table "yearly_questions", force: :cascade do |t|
    t.bigint "subject_id", null: false
    t.integer "year", null: false
    t.string "type", null: false
    t.integer "position", null: false
    t.string "slug", null: false
    t.string "heading"
    t.text "question", null: false
    t.text "solution", null: false
    t.boolean "visible", default: true
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_yearly_questions_on_slug", unique: true
    t.index ["subject_id"], name: "index_yearly_questions_on_subject_id"
  end

  add_foreign_key "notes", "notes_categories"
  add_foreign_key "notes", "notes_sub_categories"
  add_foreign_key "notes_contents", "notes"
  add_foreign_key "notes_sub_categories", "notes_categories"
  add_foreign_key "program_comments", "programs"
  add_foreign_key "program_comments", "users"
  add_foreign_key "programs", "topics"
  add_foreign_key "qa_answer_votes", "qa_answers"
  add_foreign_key "qa_answer_votes", "users"
  add_foreign_key "qa_answers", "qa_questions"
  add_foreign_key "qa_answers", "users"
  add_foreign_key "qa_question_votes", "qa_questions"
  add_foreign_key "qa_question_votes", "users"
  add_foreign_key "qa_questions", "users"
  add_foreign_key "quiz_options", "quiz_questions"
  add_foreign_key "quiz_questions", "quiz_categories"
  add_foreign_key "quiz_scores", "quiz_categories"
  add_foreign_key "quiz_scores", "users"
  add_foreign_key "votes", "users"
  add_foreign_key "yearly_question_comments", "users"
  add_foreign_key "yearly_question_comments", "yearly_questions"
  add_foreign_key "yearly_questions", "subjects"
end
