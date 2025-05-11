class Topic < ApplicationRecord
  has_many :programs, dependent: :restrict_with_error
  has_many :qa_questions, through: :programs

  validates :name, presence: true, uniqueness: true
  validates :url_name, presence: true, uniqueness: true,
            format: { with: /\A[a-z0-9-]+\z/, message: "can only contain lowercase letters, numbers, and hyphens" }

  scope :visible, -> { where(visible: true) }
  scope :ordered, -> { order(created_at: :desc) }
  scope :by_programs_count, -> {
    if column_names.include?('programs_count')
      order(programs_count: :desc)
    else
      left_joins(:programs)
        .group('topics.id')
        .order('COUNT(programs.id) DESC')
    end
  }

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

  def questions_count
    Rails.cache.fetch([self, 'questions_count']) do
      qa_questions.visible.count
    end
  end

  # Reset the programs_count counter
  def reset_programs_count
    update_column(:programs_count, programs.count)
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