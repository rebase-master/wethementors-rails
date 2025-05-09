class CreateMilestoneCompletions < ActiveRecord::Migration[7.1]
  def change
    create_table :milestone_completions do |t|
      t.references :milestone, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.boolean :completed, default: false
      t.datetime :started_at
      t.datetime :completed_at
      t.text :notes
      t.jsonb :submission_data, default: {}
      t.jsonb :metadata, default: {}

      t.timestamps
    end

    add_index :milestone_completions, [:milestone_id, :user_id], unique: true
    add_index :milestone_completions, :completed
  end
end 