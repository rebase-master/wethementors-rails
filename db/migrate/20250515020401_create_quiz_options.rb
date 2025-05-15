class CreateQuizOptions < ActiveRecord::Migration[7.2]
  def change
    create_table :quiz_options do |t|
      t.references :quiz_question, null: false, foreign_key: true
      t.string :option_text, null: false
      t.boolean :correct, default: false
      t.timestamps
    end
  end
end
