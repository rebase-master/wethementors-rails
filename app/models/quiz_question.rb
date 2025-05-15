class QuizQuestion < ApplicationRecord
  belongs_to :quiz_category
  has_many :quiz_options, dependent: :destroy

  validates :question, presence: true

  scope :with_correct_options, -> { joins(:quiz_options).where(quiz_options: { correct: true }) }
end
