class QuizProgressSerializer < ActiveModel::Serializer
  attributes :id, :completed_questions, :correct_answers, :total_attempts,
             :average_score, :last_attempt_at, :completion_percentage,
             :mastery_level

  belongs_to :user
  belongs_to :quiz_category

  def completion_percentage
    object.completion_percentage
  end

  def mastery_level
    object.mastery_level
  end
end 