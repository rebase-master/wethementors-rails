class CreateQaQuestionVotes < ActiveRecord::Migration[7.2]
  def change
    create_table :qa_question_votes do |t|
      t.references :qa_question, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :vote, null: false, default: 0

      t.timestamps
    end
  end
end
