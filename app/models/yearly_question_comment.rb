class YearlyQuestionComment < ApplicationRecord
  belongs_to :yearly_question
  belongs_to :user
end
