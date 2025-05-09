class QaVoteSerializer
  include JSONAPI::Serializer

  attributes :vote, :created_at

  attribute :user do |vote|
    {
      id: vote.user.id,
      username: vote.user.username
    }
  end
end 