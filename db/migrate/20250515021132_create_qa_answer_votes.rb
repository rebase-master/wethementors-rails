class CreateQaAnswerVotes < ActiveRecord::Migration[7.2]
  def change
    create_table :qa_answer_votes do |t|
      t.references :qa_answer, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.integer :vote, null: false, default: 0

      t.timestamps
    end
  end
end
