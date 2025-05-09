class CreateQuizScores < ActiveRecord::Migration[7.1]
  def change
    create_table :quiz_scores do |t|
      t.references :quiz_category, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :score, null: false
      t.integer :attempts, default: 1
      t.jsonb :answers, default: {}
      t.timestamps
    end

    add_index :quiz_scores, [:quiz_category_id, :user_id], unique: true
    add_index :quiz_scores, :score
    add_index :quiz_scores, :created_at
  end
end 