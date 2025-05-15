class Download < ApplicationRecord
  belongs_to :user

  validates :resource, presence: true
end 