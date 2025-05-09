class ProgramCommentSerializer
  include JSONAPI::Serializer

  attributes :comment, :deleted, :flagged, :created_at, :updated_at

  attribute :user do |comment|
    {
      id: comment.user.id,
      username: comment.user.username,
      full_name: comment.user.full_name,
      profile: comment.user.profile
    }
  end

  attribute :program do |comment|
    {
      id: comment.program.id,
      title: comment.program.title,
      description: comment.program.description
    }
  end
end
 