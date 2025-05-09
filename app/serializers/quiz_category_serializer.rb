class QuizCategorySerializer
  include JSONAPI::Serializer

  attributes :category, :description, :active, :created_at, :updated_at,
             :average_score, :total_attempts, :unique_participants

  has_many :quiz_questions, serializer: QuizQuestionSerializer
  has_many :quiz_scores, serializer: QuizScoreSerializer
end 