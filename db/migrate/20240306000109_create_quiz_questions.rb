class CreateQuizQuestions < ActiveRecord::Migration[7.1]
  def up
    # Drop the table if it exists
    drop_table :quiz_questions if table_exists?(:quiz_questions)

    create_table :quiz_questions do |t|
      t.references :quiz_category, null: false, foreign_key: true
      t.text :question, null: false
      t.text :options, array: true, default: []
      t.integer :correct_option, null: false
      t.text :explanation
      t.integer :difficulty, default: 1
      t.boolean :active, default: true
      t.timestamps
    end

    add_index :quiz_questions, :active
    add_index :quiz_questions, :difficulty
  end

  def down
    drop_table :quiz_questions
  end
end 