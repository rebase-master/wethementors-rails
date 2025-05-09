class QaAnswer < ApplicationRecord
  belongs_to :qa_question
  belongs_to :user
  has_many :qa_votes, as: :votable, dependent: :destroy

  validates :answer, presence: true
  validates :user_id, presence: true
  validates :qa_question_id, presence: true

  scope :visible, -> { where(visible: true) }
  scope :recent, -> { order(created_at: :asc) }

  def upvotes_count
    qa_votes.where(vote: 1).count
  end

  def downvotes_count
    qa_votes.where(vote: -1).count
  end

  def vote_count
    upvotes_count - downvotes_count
  end
end 