class CreateNotesContents < ActiveRecord::Migration[7.2]
  def change
    create_table :notes_contents do |t|
      t.references :note, null: false, foreign_key: true
      t.string :heading, null: false
      t.string :slug, null: false
      t.string :cover_image
      t.text :content, null: false
      t.string :extract
      t.string :source
      t.boolean :deleted, default: false

      t.timestamps
    end
    add_index :notes_contents, :slug, unique: true
  end
end
