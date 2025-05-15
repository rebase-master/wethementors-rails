class EmailUser < ApplicationRecord
  validates :email, presence: true, uniqueness: true
end 