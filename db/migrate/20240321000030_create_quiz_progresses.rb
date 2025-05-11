class CreateQuizProgresses < ActiveRecord::Migration[7.1]
  def change
    create_table :quiz_progresses do |t|
      t.references :user, null: false, foreign_key: true
      t.references :quiz_category, null: false, foreign_key: true
      t.integer :completed_questions, default: 0
      t.integer :correct_answers, default: 0
      t.integer :total_attempts, default: 0
      t.decimal :average_score, precision: 5, scale: 2, default: 0
      t.datetime :last_attempt_at

      t.timestamps
    end

    add_index :quiz_progresses, [:user_id, :quiz_category_id], unique: true
  end
end 