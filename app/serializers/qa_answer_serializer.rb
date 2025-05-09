class QaAnswerSerializer
  include JSONAPI::Serializer

  attributes :answer, :visible, :created_at, :updated_at, :vote_count

  attribute :user do |answer|
    {
      id: answer.user.id,
      username: answer.user.username,
      full_name: answer.user.full_name,
      profile: answer.user.profile
    }
  end

  has_many :qa_votes, serializer: QaVoteSerializer
end 