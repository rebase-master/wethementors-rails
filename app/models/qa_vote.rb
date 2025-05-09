class QaVote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :user_id, presence: true
  validates :vote, presence: true, inclusion: { in: [-1, 1] }
  validates :votable_id, uniqueness: { scope: [:user_id, :votable_type] }

  scope :upvotes, -> { where(vote: 1) }
  scope :downvotes, -> { where(vote: -1) }
end 