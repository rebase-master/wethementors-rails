class QuizQuestionSerializer
  include JSONAPI::Serializer

  attributes :question, :options, :difficulty, :active, :created_at, :updated_at

  attribute :correct_option do |question|
    question.correct_option unless question.instance_variable_get(:@hide_correct_answer)
  end

  attribute :explanation do |question|
    question.explanation unless question.instance_variable_get(:@hide_correct_answer)
  end
end 