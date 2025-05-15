class Vote < ApplicationRecord
  belongs_to :votable, polymorphic: true
  belongs_to :user

  validates :vote, inclusion: { in: [-1, 1] }
end
