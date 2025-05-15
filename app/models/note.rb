class Note < ApplicationRecord
  belongs_to :notes_category
  belongs_to :notes_sub_category
  has_many :notes_contents

  validates :slug, presence: true, uniqueness: true
end
