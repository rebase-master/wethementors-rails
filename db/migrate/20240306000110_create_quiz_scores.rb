class CreateQuizScores < ActiveRecord::Migration[7.1]
  def up
    # Drop the table if it exists
    drop_table :quiz_scores if table_exists?(:quiz_scores)

    create_table :quiz_scores do |t|
      t.references :user, null: false, foreign_key: true
      t.references :quiz_category, null: false, foreign_key: true
      t.integer :score, null: false
      t.integer :total_questions, null: false
      t.integer :correct_answers, null: false
      t.integer :time_taken, comment: "Time taken in seconds"
      t.jsonb :metadata, default: {}
      t.timestamps
    end

    add_index :quiz_scores, [:user_id, :quiz_category_id]
    add_index :quiz_scores, :score
  end

  def down
    drop_table :quiz_scores
  end
end 