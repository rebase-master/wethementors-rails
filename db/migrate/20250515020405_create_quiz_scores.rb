class CreateQuizScores < ActiveRecord::Migration[7.2]
  def change
    create_table :quiz_scores do |t|
      t.references :quiz_category, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :score
      t.integer :attempts

      t.timestamps
    end
  end
end
