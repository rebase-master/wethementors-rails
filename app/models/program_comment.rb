class ProgramComment < ApplicationRecord
  belongs_to :program
  belongs_to :user

  validates :comment, presence: true
  validates :user_id, presence: true
  validates :program_id, presence: true

  scope :active, -> { where(deleted: false) }
  scope :flagged, -> { where(flagged: true) }
  scope :recent, -> { order(created_at: :desc) }

  def soft_delete
    update(deleted: true)
  end

  def flag
    update(flagged: true)
  end

  def unflag
    update(flagged: false)
  end

  def self.for_program(program_id, page: 1, per_page: 15)
    active
      .where(program_id: program_id)
      .includes(:user)
      .recent
      .page(page)
      .per(per_page)
  end

  def self.by_user(user_id, page: 1, per_page: 15)
    active
      .where(user_id: user_id)
      .includes(:program)
      .recent
      .page(page)
      .per(per_page)
  end
end 