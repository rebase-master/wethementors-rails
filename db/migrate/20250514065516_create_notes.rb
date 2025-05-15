class CreateNotes < ActiveRecord::Migration[7.2]
  def change
    create_table :notes do |t|
      t.references :notes_category, null: false, foreign_key: true
      t.references :notes_sub_category, null: false, foreign_key: true
      t.string :slug, null: false
      t.boolean :deleted, default: false

      t.timestamps
    end
    add_index :notes, :slug, unique: true
  end
end
