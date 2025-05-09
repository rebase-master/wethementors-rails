class Milestone < ApplicationRecord
  belongs_to :program_section
  has_many :milestone_completions, dependent: :destroy
  has_many :milestone_resources, dependent: :destroy

  validates :title, presence: true
  validates :description, presence: true
  validates :order, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :program_section_id, presence: true
  validates :milestone_type, presence: true, inclusion: { in: %w[reading quiz assignment project] }
  validates :estimated_duration, numericality: { greater_than: 0 }, allow_nil: true

  scope :ordered, -> { order(order: :asc) }
  scope :with_resources, -> { includes(:milestone_resources) }

  def self.next_order(section_id)
    where(program_section_id: section_id).maximum(:order).to_i + 1
  end

  def completed_by?(user)
    milestone_completions.exists?(user_id: user.id, completed: true)
  end

  def completion_for(user)
    milestone_completions.find_by(user_id: user.id)
  end

  def start_for(user)
    return if completed_by?(user)

    milestone_completions.create!(
      user_id: user.id,
      started_at: Time.current
    )
  end

  def complete_for(user)
    completion = completion_for(user)
    return unless completion

    completion.update!(
      completed: true,
      completed_at: Time.current
    )
  end

  def time_spent_for(user)
    completion = completion_for(user)
    return 0 unless completion&.started_at

    end_time = completion.completed_at || Time.current
    (end_time - completion.started_at).to_i
  end
end 