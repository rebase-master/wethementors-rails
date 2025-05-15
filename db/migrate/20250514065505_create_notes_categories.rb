class CreateNotesCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :notes_categories do |t|
      t.string :category
      t.string :type
      t.boolean :visible

      t.timestamps
    end
  end
end
