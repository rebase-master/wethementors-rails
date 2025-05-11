class CreateProgramComments < ActiveRecord::Migration[7.1]
  def change
    create_table :program_comments do |t|
      t.references :program, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.text :comment, null: false
      t.boolean :deleted, default: false
      t.boolean :flagged, default: false
      t.timestamps
    end

    add_index :program_comments, :deleted
    add_index :program_comments, :flagged
    add_index :program_comments, :created_at
  end
end 