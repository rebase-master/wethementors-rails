class ProfileOptionSerializer < ActiveModel::Serializer
  attributes :id, :name, :display_name, :options, :required, :public, :created_at, :updated_at

  has_many :user_data
  has_many :users, through: :user_data
end 