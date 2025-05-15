class NotesContent < ApplicationRecord
  belongs_to :note

  validates :heading, :slug, :content, presence: true
end
