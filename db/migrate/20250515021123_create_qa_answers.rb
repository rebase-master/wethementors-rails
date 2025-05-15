class CreateQaAnswers < ActiveRecord::Migration[7.2]
  def change
    create_table :qa_answers do |t|
      t.references :qa_question, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :answer, null: false
      t.boolean :visible, default: true
      t.datetime :deleted_at

      t.timestamps
    end
  end
end
