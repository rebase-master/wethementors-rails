class QuizQuestion < ApplicationRecord
  belongs_to :quiz_category

  validates :question, presence: true
  validates :options, presence: true, length: { minimum: 2 }
  validates :correct_option, presence: true, inclusion: { in: 0..3 }
  validates :difficulty, inclusion: { in: 1..5 }

  scope :active, -> { where(active: true) }
  scope :by_difficulty, ->(level) { where(difficulty: level) }

  def correct_answer
    options[correct_option]
  end

  def check_answer(selected_option)
    selected_option.to_i == correct_option
  end

  def self.random_questions(category_id, count: 10, difficulty: nil)
    questions = active.where(quiz_category_id: category_id)
    questions = questions.by_difficulty(difficulty) if difficulty
    questions.order('RANDOM()').limit(count)
  end
end 