class CreateYearlyQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :yearly_questions do |t|
      t.references :subject, null: false, foreign_key: true
      t.integer :year, null: false
      t.string :type, null: false
      t.integer :position, null: false
      t.string :slug, null: false
      t.string :heading
      t.text :question, null: false
      t.text :solution, null: false
      t.boolean :visible, default: true

      t.timestamps
    end
    add_index :yearly_questions, :slug, unique: true
  end
end
