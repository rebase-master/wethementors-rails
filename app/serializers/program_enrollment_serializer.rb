class ProgramEnrollmentSerializer < ActiveModel::Serializer
  attributes :id, :status, :progress, :started_at, :completed_at,
             :dropped_at, :time_spent, :estimated_completion_time,
             :notes, :metadata

  belongs_to :user
  belongs_to :program

  def time_spent
    object.time_spent
  end

  def estimated_completion_time
    object.estimated_completion_time
  end
end 