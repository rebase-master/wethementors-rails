class Subject < ApplicationRecord
  has_many :yearly_questions, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
  validates :url_name, presence: true, uniqueness: true,
            format: { with: /\A[a-z0-9-]+\z/, message: "can only contain lowercase letters, numbers, and hyphens" }

  scope :visible, -> { where(visible: true) }
  scope :ordered, -> { order(created_at: :desc) }

  before_validation :generate_url_name, on: :create

  def self.find_by_name(name)
    find_by(name: name)
  end

  def self.find_by_url_name(url_name)
    find_by(url_name: url_name)
  end

  def to_param
    url_name
  end

  private

  def generate_url_name
    return if url_name.present?
    
    base_url_name = name.parameterize
    self.url_name = base_url_name
    
    # Add number suffix if url_name already exists
    counter = 1
    while self.class.exists?(url_name: url_name)
      self.url_name = "#{base_url_name}-#{counter}"
      counter += 1
    end
  end
end 