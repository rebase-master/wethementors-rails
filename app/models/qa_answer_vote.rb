class QaAnswerVote < ApplicationRecord
  belongs_to :qa_answer
  belongs_to :user
end
