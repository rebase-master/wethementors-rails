class CreateMilestones < ActiveRecord::Migration[7.1]
  def change
    create_table :milestones do |t|
      t.references :program_section, null: false, foreign_key: true
      t.string :title, null: false
      t.text :description, null: false
      t.integer :order, null: false
      t.string :milestone_type, null: false
      t.integer :estimated_duration
      t.boolean :required, default: true
      t.jsonb :content, default: {}
      t.jsonb :metadata, default: {}

      t.timestamps
    end

    add_index :milestones, [:program_section_id, :order]
    add_index :milestones, :milestone_type
  end
end 