class QuizCategory < ApplicationRecord
  has_many :quiz_questions, dependent: :destroy
  has_many :quiz_scores, dependent: :destroy

  validates :category, presence: true, uniqueness: true

  scope :active, -> { where(active: true) }

  def self.find_by_category(category_name)
    find_by(category: category_name)
  end

  def high_scores(limit: 10)
    quiz_scores
      .includes(:user)
      .order(score: :desc)
      .limit(limit)
  end

  def average_score
    quiz_scores.average(:score)&.round(2) || 0
  end

  def total_attempts
    quiz_scores.sum(:attempts)
  end

  def unique_participants
    quiz_scores.select(:user_id).distinct.count
  end
end 