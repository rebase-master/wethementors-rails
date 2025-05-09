class ProgramEnrollment < ApplicationRecord
  belongs_to :user
  belongs_to :program

  validates :user_id, uniqueness: { scope: :program_id }
  validates :status, presence: true, inclusion: { in: %w[enrolled in_progress completed dropped] }
  validates :progress, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :started_at, presence: true
  validates :completed_at, presence: true, if: :completed?

  scope :active, -> { where(status: %w[enrolled in_progress]) }
  scope :completed, -> { where(status: 'completed') }
  scope :dropped, -> { where(status: 'dropped') }
  scope :recent, -> { order(updated_at: :desc) }

  def self.enroll(user_id, program_id)
    create!(
      user_id: user_id,
      program_id: program_id,
      status: 'enrolled',
      progress: 0,
      started_at: Time.current
    )
  end

  def update_progress(new_progress)
    return if completed? || dropped?

    self.progress = new_progress
    self.status = 'completed' if new_progress >= 100
    self.completed_at = Time.current if completed?
    save!
  end

  def drop
    return if completed?

    update!(
      status: 'dropped',
      dropped_at: Time.current
    )
  end

  def completed?
    status == 'completed'
  end

  def dropped?
    status == 'dropped'
  end

  def active?
    %w[enrolled in_progress].include?(status)
  end

  def time_spent
    return 0 unless started_at

    end_time = completed_at || dropped_at || Time.current
    (end_time - started_at).to_i
  end

  def estimated_completion_time
    return nil unless program.estimated_duration
    return 0 if completed?

    program.estimated_duration - time_spent
  end
end 