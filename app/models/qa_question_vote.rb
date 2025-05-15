class QaQuestionVote < ApplicationRecord
  belongs_to :qa_question
  belongs_to :user
end
