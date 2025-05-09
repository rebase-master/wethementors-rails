class MilestoneSerializer
  include JSONAPI::Serializer

  attributes :title, :description, :order, :milestone_type, :estimated_duration,
             :required, :content, :metadata

  attribute :completed do |milestone, params|
    if params[:current_user]
      milestone.milestone_completions.exists?(user_id: params[:current_user].id, completed: true)
    else
      false
    end
  end

  attribute :completion_data do |milestone, params|
    if params[:current_user]
      completion = milestone.milestone_completions.find_by(user_id: params[:current_user].id)
      {
        started_at: completion&.started_at,
        completed_at: completion&.completed_at,
        submission_data: completion&.submission_data
      }
    else
      nil
    end
  end

  belongs_to :program_section
end 