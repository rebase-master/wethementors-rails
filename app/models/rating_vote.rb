class RatingVote < ApplicationRecord
  belongs_to :program_rating
  belongs_to :user

  validates :user_id, uniqueness: { scope: :program_rating_id, message: 'has already voted on this review' }
  validates :helpful, inclusion: { in: [true, false] }

  scope :helpful, -> { where(helpful: true) }
  scope :unhelpful, -> { where(helpful: false) }
end 