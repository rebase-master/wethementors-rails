class UserData < ApplicationRecord
  belongs_to :user
  belongs_to :profile_option

  validates :user_id, uniqueness: { scope: :profile_option_id }
  validates :data, presence: true, if: :required?

  private

  def required?
    profile_option&.required?
  end
end 