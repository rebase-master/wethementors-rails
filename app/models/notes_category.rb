class NotesCategory < ApplicationRecord
  has_many :notes, dependent: :destroy
  has_many :notes_sub_categories

  validates :category, presence: true, uniqueness: true

  scope :visible, -> { where(visible: true) }
  scope :by_type, ->(type) { where(type: type) }

  before_validation :normalize_category

  private

  def normalize_category
    self.category = category.to_s.downcase if category.present?
  end
end
