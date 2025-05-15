class Trivium < ApplicationRecord
  validates :fact, presence: true

  scope :random, -> { order('RANDOM()') }
end 