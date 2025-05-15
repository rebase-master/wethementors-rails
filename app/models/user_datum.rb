class UserDatum < ApplicationRecord
  belongs_to :user
  belongs_to :profile_option
  validates :user_id, presence: true
  validates :profile_option_id, presence: true
end 