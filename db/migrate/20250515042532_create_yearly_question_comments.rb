class CreateYearlyQuestionComments < ActiveRecord::Migration[7.2]
  def change
    create_table :yearly_question_comments do |t|
      t.references :yearly_question, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :comment, null: false
      t.boolean :deleted, default: false
      t.boolean :flagged, default: false

      t.timestamps
    end
  end
end
