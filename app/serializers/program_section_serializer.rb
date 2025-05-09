class ProgramSectionSerializer
  include JSONAPI::Serializer

  attributes :title, :description, :order, :required, :metadata

  attribute :completed do |section, params|
    if params[:current_user]
      section.section_completions.exists?(user_id: params[:current_user].id, completed: true)
    else
      false
    end
  end

  attribute :completion_percentage do |section, params|
    if params[:current_user]
      total_milestones = section.milestones.count
      return 0 if total_milestones.zero?

      completed_milestones = section.milestones.joins(:milestone_completions)
        .where(milestone_completions: { user_id: params[:current_user].id, completed: true })
        .count

      (completed_milestones.to_f / total_milestones * 100).round(2)
    else
      0
    end
  end

  has_many :milestones
  belongs_to :program
end 