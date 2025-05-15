class Riddle < ApplicationRecord
  validates :riddle, presence: true
  validates :answer, presence: true

  scope :visible, -> { where(visible: true) }
  scope :random, -> { order('RANDOM()') }
end 