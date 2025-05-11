class AddProgramsCountToTopicsAndSubjects < ActiveRecord::Migration[7.1]
  def up
    # Add programs_count to topics if it doesn't exist
    unless column_exists?(:topics, :programs_count)
      add_column :topics, :programs_count, :integer, default: 0, null: false
    end

    # Add programs_count to subjects if it doesn't exist
    unless column_exists?(:subjects, :programs_count)
      add_column :subjects, :programs_count, :integer, default: 0, null: false
    end

    # Reset counters for existing records
    Topic.find_each { |topic| Topic.reset_counters(topic.id, :programs) }
    Subject.find_each { |subject| Subject.reset_counters(subject.id, :programs) }
  end

  def down
    remove_column :topics, :programs_count if column_exists?(:topics, :programs_count)
    remove_column :subjects, :programs_count if column_exists?(:subjects, :programs_count)
  end
end 