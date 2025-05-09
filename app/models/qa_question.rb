class QaQuestion < ApplicationRecord
  belongs_to :user
  has_many :qa_answers, dependent: :destroy
  has_many :qa_votes, as: :votable, dependent: :destroy

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
    where("tags LIKE ?", "%#{tag}%")
  }

  def upvotes_count
    qa_votes.where(vote: 1).count
  end

  def downvotes_count
    qa_votes.where(vote: -1).count
  end

  def vote_count
    upvotes_count - downvotes_count
  end

  def answer_count
    qa_answers.visible.count
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