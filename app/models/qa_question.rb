class QAQuestion < ApplicationRecord
  belongs_to :user
  has_many :qa_answers, dependent: :destroy
  has_many :votes, as: :votable, dependent: :destroy

  validates :question, presence: true

  scope :active, -> { where(deleted_at: nil) }
  scope :visible, -> { where(visible: true) }

  def soft_delete
    update(deleted_at: Time.current)
  end
end
