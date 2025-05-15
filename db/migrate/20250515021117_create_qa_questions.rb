class CreateQaQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :qa_questions do |t|
      t.references :user, null: false, foreign_key: true
      t.string :question, null: false
      t.text :description
      t.boolean :visible, default: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
