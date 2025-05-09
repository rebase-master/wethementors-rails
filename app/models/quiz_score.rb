class QuizScore < ApplicationRecord
  belongs_to :quiz_category
  belongs_to :user

  validates :score, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :attempts, presence: true, numericality: { greater_than: 0 }
  validates :quiz_category_id, uniqueness: { scope: :user_id }

  scope :recent, -> { order(created_at: :desc) }
  scope :high_scores, -> { order(score: :desc) }

  def self.save_score(category_id, user_id, score, answers = {})
    score_record = find_or_initialize_by(
      quiz_category_id: category_id,
      user_id: user_id
    )

    if score_record.new_record?
      score_record.score = score
      score_record.answers = answers
    else
      score_record.score = [score_record.score, score].max
      score_record.attempts += 1
      score_record.answers = answers if score > score_record.score
    end

    score_record.save
    score_record
  end

  def percentage_score
    return 0 if quiz_category.quiz_questions.active.count.zero?
    ((score.to_f / quiz_category.quiz_questions.active.count) * 100).round(2)
  end
end 