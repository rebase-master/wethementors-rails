class ProgramSection < ApplicationRecord
  belongs_to :program
  has_many :milestones, dependent: :destroy
  has_many :section_completions, dependent: :destroy

  validates :title, presence: true
  validates :order, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :program_id, presence: true

  scope :ordered, -> { order(order: :asc) }
  scope :with_milestones, -> { includes(:milestones) }

  def self.next_order(program_id)
    where(program_id: program_id).maximum(:order).to_i + 1
  end

  def completed_by?(user)
    section_completions.exists?(user_id: user.id, completed: true)
  end

  def completion_percentage(user)
    return 0 if milestones.empty?

    completed = milestones.count { |m| m.completed_by?(user) }
    ((completed.to_f / milestones.count) * 100).round(2)
  end

  def estimated_duration
    milestones.sum(&:estimated_duration)
  end

  def next_milestone_for(user)
    milestones.ordered.find { |m| !m.completed_by?(user) }
  end
end 