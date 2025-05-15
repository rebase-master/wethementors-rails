class CreateQuizQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :quiz_questions do |t|
      t.references :quiz_category, null: false, foreign_key: true
      t.string :question, null: false
      # Removed answer field to support multiple correct answers via QuizOption
      t.timestamps
    end
  end
end
