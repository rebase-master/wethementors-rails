class NotesSubCategory < ApplicationRecord
  belongs_to :notes_category
  has_many :notes

  validates :sub_category, presence: true
end
