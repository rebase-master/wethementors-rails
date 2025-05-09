class QuizProgress < ApplicationRecord
  belongs_to :user
  belongs_to :quiz_category

  validates :user_id, uniqueness: { scope: :quiz_category_id }
  validates :completed_questions, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :correct_answers, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :total_attempts, presence: true, numericality: { greater_than_or_equal_to: 0 }
  validates :average_score, presence: true, numericality: { greater_than_or_equal_to: 0, less_than_or_equal_to: 100 }
  validates :last_attempt_at, presence: true

  scope :recent, -> { order(last_attempt_at: :desc) }
  scope :by_performance, -> { order(average_score: :desc) }

  def self.update_progress(category_id, user_id, score, total_questions)
    progress = find_or_initialize_by(
      quiz_category_id: category_id,
      user_id: user_id
    )

    progress.completed_questions += total_questions
    progress.correct_answers += score
    progress.total_attempts += 1
    progress.average_score = ((progress.correct_answers.to_f / progress.completed_questions) * 100).round(2)
    progress.last_attempt_at = Time.current

    progress.save
    progress
  end

  def completion_percentage
    return 0 if quiz_category.quiz_questions.active.count.zero?
    ((completed_questions.to_f / quiz_category.quiz_questions.active.count) * 100).round(2)
  end

  def mastery_level
    case average_score
    when 0..40 then 'beginner'
    when 41..60 then 'intermediate'
    when 61..80 then 'advanced'
    else 'expert'
    end
  end
end 