class AddFieldsToPrograms < ActiveRecord::Migration[7.1]
  def change
    add_column :programs, :difficulty_level, :integer
    add_column :programs, :estimated_duration, :integer, comment: 'Duration in minutes'
    add_column :programs, :description, :text
    add_column :programs, :learning_objectives, :text
    add_column :programs, :resources, :jsonb, default: {}
    add_column :programs, :metadata, :jsonb, default: {}

    add_index :programs, :difficulty_level
    add_index :programs, :estimated_duration
  end
end 