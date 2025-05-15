class CreateQuotes < ActiveRecord::Migration[7.2]
  def change
    create_table :quotes do |t|
      t.text :quote, null: false
      t.string :slug, null: false
      t.string :author
      t.boolean :visible, default: true
      t.timestamps
    end

    add_index :quotes, :slug, unique: true
    add_index :quotes, :visible
  end
end 