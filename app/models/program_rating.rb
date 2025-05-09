class ProgramRating < ApplicationRecord
  belongs_to :program
  belongs_to :user
  has_many :rating_votes, dependent: :destroy

  validates :rating, presence: true,
                    numericality: { only_integer: true, greater_than_or_equal_to: 1, less_than_or_equal_to: 5 }
  validates :user_id, uniqueness: { scope: :program_id, message: 'has already rated this program' }
  validates :review, length: { minimum: 10, maximum: 1000 }, allow_nil: true

  scope :verified, -> { where(verified_completion: true) }
  scope :flagged, -> { where(flagged: true) }
  scope :recent, -> { order(created_at: :desc) }
  scope :helpful, -> { order(helpful_votes_count: :desc) }

  def self.average_rating(program_id)
    where(program_id: program_id).average(:rating)&.round(1)
  end

  def self.rating_distribution(program_id)
    where(program_id: program_id)
      .group(:rating)
      .count
      .transform_keys(&:to_i)
  end

  def update_helpful_votes
    update_columns(
      helpful_votes_count: rating_votes.helpful.count,
      unhelpful_votes_count: rating_votes.unhelpful.count
    )
  end

  def mark_as_verified
    update(verified_completion: true) if program.completed_by?(user)
  end

  def flag
    update(flagged: true)
  end

  def unflag
    update(flagged: false)
  end

  def vote_helpful(user)
    return false if user_id == user.id

    vote = rating_votes.find_or_initialize_by(user_id: user.id)
    vote.helpful = true
    vote.save
    update_helpful_votes
  end

  def vote_unhelpful(user)
    return false if user_id == user.id

    vote = rating_votes.find_or_initialize_by(user_id: user.id)
    vote.helpful = false
    vote.save
    update_helpful_votes
  end

  def remove_vote(user)
    rating_votes.find_by(user_id: user.id)&.destroy
    update_helpful_votes
  end
end 