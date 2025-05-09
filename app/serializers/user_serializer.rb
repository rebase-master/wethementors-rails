class UserSerializer
  include JSONAPI::Serializer

  attributes :id, :email, :username, :first_name, :last_name, :gender, :admin, :confirmed, :created_at, :updated_at

  attribute :full_name do |user|
    user.full_name
  end

  attribute :profile do |user|
    user.user_data&.as_json(only: [:data])
  end
end 