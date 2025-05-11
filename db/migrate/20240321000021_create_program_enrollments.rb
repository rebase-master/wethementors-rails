class CreateProgramEnrollments < ActiveRecord::Migration[7.1]
  def change
    create_table :program_enrollments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :program, null: false, foreign_key: true
      t.string :status, null: false
      t.integer :progress, default: 0
      t.datetime :started_at, null: false
      t.datetime :completed_at
      t.datetime :dropped_at
      t.text :notes
      t.jsonb :metadata, default: {}

      t.timestamps
    end

    add_index :program_enrollments, [:user_id, :program_id], unique: true
    add_index :program_enrollments, :status
    add_index :program_enrollments, :progress
  end
end 