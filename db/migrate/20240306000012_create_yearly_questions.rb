class CreateYearlyQuestions < ActiveRecord::Migration[7.1]
  def change
    create_table :yearly_questions do |t|
      t.integer :year, null: false
      t.string :subject, null: false
      t.string :type, null: false
      t.integer :position
      t.string :slug, null: false
      t.string :heading
      t.text :question, null: false
      t.text :solution, null: false
      t.boolean :visible, default: true
      t.timestamps
    end

    add_index :yearly_questions, :year
    add_index :yearly_questions, :subject
    add_index :yearly_questions, :type
    add_index :yearly_questions, :slug, unique: true
    add_index :yearly_questions, :visible
    add_index :yearly_questions, [:year, :subject, :type]
  end
end 