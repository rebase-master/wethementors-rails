class CreateQaAnswers < ActiveRecord::Migration[7.1]
  def change
    create_table :qa_answers do |t|
      t.references :qa_question, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :answer, null: false
      t.boolean :visible, default: true
      t.timestamps
    end

    add_index :qa_answers, :visible
    add_index :qa_answers, :created_at
  end
end 