class CreateProgramSections < ActiveRecord::Migration[7.1]
  def change
    create_table :program_sections do |t|
      t.references :program, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description
      t.integer :order, null: false
      t.boolean :required, default: true
      t.jsonb :metadata, default: {}

      t.timestamps
    end

    add_index :program_sections, [:program_id, :order]
  end
end 