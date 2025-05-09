class ProfileOption < ApplicationRecord
  has_many :user_data, dependent: :destroy
  has_many :users, through: :user_data

  validates :name, presence: true, uniqueness: true
  validates :options, presence: true, uniqueness: true

  scope :public_options, -> { where(public: true) }
  scope :required_options, -> { where(required: true) }

  def display_name
    name.titleize
  end
end 