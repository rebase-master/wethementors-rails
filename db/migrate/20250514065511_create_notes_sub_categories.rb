class CreateNotesSubCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :notes_sub_categories do |t|
      t.references :notes_category, null: false, foreign_key: true
      t.string :sub_category
      t.boolean :visible

      t.timestamps
    end
  end
end
