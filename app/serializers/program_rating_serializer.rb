class ProgramRatingSerializer
  include JSONAPI::Serializer

  attributes :rating, :review, :verified_completion, :helpful_votes_count,
             :unhelpful_votes_count, :flagged, :created_at, :updated_at

  attribute :user_vote do |rating, params|
    if params[:current_user]
      vote = rating.rating_votes.find_by(user_id: params[:current_user].id)
      vote&.helpful
    end
  end

  belongs_to :user
  belongs_to :program
end 