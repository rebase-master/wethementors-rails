class QuizOption < ApplicationRecord
  belongs_to :quiz_question

  validates :option_text, presence: true

  scope :correct, -> { where(correct: true) }
end
