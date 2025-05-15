class ProgramComment < ApplicationRecord
  belongs_to :program
  belongs_to :user

  validates :comment, presence: true

  scope :active, -> { where(deleted: false) }
  scope :flagged, -> { where(flagged: true) }
  scope :recent, -> { order(created_at: :desc) }

  def soft_delete
    update(deleted: true)
  end
end
