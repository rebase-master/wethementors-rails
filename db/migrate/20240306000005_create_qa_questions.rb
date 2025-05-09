class CreateQaQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :qa_questions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :topic
      t.string :tags
      t.text :question, null: false
      t.text :description
      t.boolean :visible, default: true
      t.timestamps
    end

    add_index :qa_questions, :visible
    add_index :qa_questions, :created_at
    add_index :qa_questions, :topic
  end
end 