class QAAnswer < ApplicationRecord
  belongs_to :qa_question
  belongs_to :user
  has_many :votes, as: :votable, dependent: :destroy

  validates :answer, presence: true

  scope :active, -> { where(deleted_at: nil) }
  scope :visible, -> { where(visible: true) }

  def soft_delete
    update(deleted_at: Time.current)
  end
end
