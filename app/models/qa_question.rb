class QaQuestion < ApplicationRecord
  belongs_to :user
  has_many :qa_answers, dependent: :destroy
  has_many :qa_votes, as: :votable, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  validates :question, presence: true
  validates :user_id, presence: true

  scope :visible, -> { where(visible: true) }
  scope :recent, -> { order(created_at: :desc) }
  scope :popular, -> { 
    left_joins(:qa_answers)
      .group('qa_questions.id')
      .order('COUNT(qa_answers.id) DESC')
  }
  scope :unanswered, -> {
    left_joins(:qa_answers)
      .where(qa_answers: { id: nil })
      .visible
  }
  scope :with_tag, ->(tag) {
    joins(:tags).where(tags: { name: tag })
  }

  def upvotes_count
    Rails.cache.fetch([self, 'upvotes_count']) do
      qa_votes.where(vote: 1).count
    end
  end

  def downvotes_count
    Rails.cache.fetch([self, 'downvotes_count']) do
      qa_votes.where(vote: -1).count
    end
  end

  def vote_count
    upvotes_count - downvotes_count
  end

  def answers_count
    Rails.cache.fetch([self, 'answers_count']) do
      qa_answers.visible.count
    end
  end

  def related_questions(limit: 5)
    return [] if tags.blank?
    
    tag_list = tags.split(',')
    QaQuestion.visible
      .where.not(id: id)
      .where("tags && ARRAY[?]::varchar[]", tag_list)
      .order('RANDOM()')
      .limit(limit)
  end
end 