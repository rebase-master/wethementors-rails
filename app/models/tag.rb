class Tag < ApplicationRecord
  has_many :taggings, dependent: :destroy
  has_many :programs, through: :taggings, source: :taggable, source_type: 'Program'
  has_many :yearly_questions, through: :taggings, source: :taggable, source_type: 'YearlyQuestion'

  validates :name, presence: true, uniqueness: true,
            format: { with: /\A[a-z0-9-]+\z/, message: "can only contain lowercase letters, numbers, and hyphens" }

  scope :ordered, -> { order(name: :asc) }

  before_validation :normalize_name

  def self.find_or_create_by_name(name)
    find_or_create_by(name: name.parameterize)
  end

  def self.find_by_name(name)
    find_by(name: name.parameterize)
  end

  def to_param
    name
  end

  private

  def normalize_name
    return if name.blank?
    self.name = name.parameterize
  end
end 