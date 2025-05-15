class AddFieldsToQuizQuestions < ActiveRecord::Migration[7.2]
  def change
    add_column :quiz_questions, :difficulty, :integer
    add_column :quiz_questions, :slug, :string
    add_index :quiz_questions, :slug, unique: true
  end
end 