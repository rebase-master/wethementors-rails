class NotesCategory < ApplicationRecord
  has_many :notes
  has_many :notes_sub_categories

  validates :category, presence: true, uniqueness: true
end
