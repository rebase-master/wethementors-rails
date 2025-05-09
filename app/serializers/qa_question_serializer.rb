class QaQuestionSerializer
  include JSONAPI::Serializer

  attributes :question, :description, :topic, :tags, :visible, :created_at, :updated_at,
             :vote_count, :answer_count

  attribute :user do |question|
    {
      id: question.user.id,
      username: question.user.username,
      full_name: question.user.full_name,
      profile: question.user.profile
    }
  end

  has_many :qa_answers, serializer: QaAnswerSerializer
  has_many :qa_votes, serializer: QaVoteSerializer
end 