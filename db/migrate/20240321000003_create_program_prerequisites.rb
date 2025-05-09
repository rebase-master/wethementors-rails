class CreateProgramPrerequisites < ActiveRecord::Migration[7.1]
  def change
    create_table :program_prerequisites do |t|
      t.references :program, null: false, foreign_key: true
      t.references :prerequisite_program, null: false, foreign_key: { to_table: :programs }
      t.text :notes

      t.timestamps
    end

    add_index :program_prerequisites, [:program_id, :prerequisite_program_id], unique: true, name: 'index_program_prerequisites_on_program_and_prereq'
  end
end 