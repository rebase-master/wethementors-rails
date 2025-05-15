class QuizScore < ApplicationRecord
  belongs_to :quiz_category
  belongs_to :user
end
