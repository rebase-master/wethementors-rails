class CreateSectionCompletions < ActiveRecord::Migration[7.1]
  def change
    create_table :section_completions do |t|
      t.references :user, null: false, foreign_key: true
      t.references :program_section, null: false, foreign_key: true
      t.boolean :completed, default: false
      t.timestamps
    end

    add_index :section_completions, [:user_id, :program_section_id], unique: true
    add_index :section_completions, :completed
  end
end 