class CreatePrograms < ActiveRecord::Migration[7.2]
  def change
    create_table :programs do |t|
      t.references :topic, null: false, foreign_key: true
      t.string :heading
      t.string :slug, null: false
      t.text :question, null: false
      t.text :solution, null: false
      t.boolean :visible, default: true

      t.timestamps
    end
    add_index :programs, :slug, unique: true
  end
end
