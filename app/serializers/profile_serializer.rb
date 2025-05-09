class ProfileSerializer < ActiveModel::Serializer
  attributes :id, :name, :data, :required, :public, :created_at, :updated_at

  belongs_to :user
  belongs_to :profile_option

  def name
    object.profile_option&.display_name
  end

  def required
    object.profile_option&.required
  end

  def public
    object.profile_option&.public
  end
end 