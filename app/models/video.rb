class Video < ApplicationRecord
  validates :heading, presence: true
  validates :link, presence: true
end 