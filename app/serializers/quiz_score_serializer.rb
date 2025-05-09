class QuizScoreSerializer
  include JSONAPI::Serializer

  attributes :score, :attempts, :answers, :created_at, :updated_at, :percentage_score

  attribute :user do |score|
    {
      id: score.user.id,
      username: score.user.username,
      full_name: score.user.full_name
    }
  end

  attribute :quiz_category do |score|
    {
      id: score.quiz_category.id,
      category: score.quiz_category.category
    }
  end
end 