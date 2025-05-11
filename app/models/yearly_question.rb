class YearlyQuestion < ApplicationRecord
  has_many :quiz_attempts, dependent: :destroy
  has_many :attempting_users, through: :quiz_attempts, source: :user

  validates :year, presence: true, numericality: { only_integer: true }
  validates :subject, presence: true
  validates :type, presence: true
  validates :question, presence: true
  validates :solution, presence: true
  validates :slug, presence: true, uniqueness: true

  scope :visible, -> { where(visible: true) }
  scope :by_year, ->(year) { where(year: year) }
  scope :by_subject, ->(subject) { where(subject: subject) }
  scope :by_type, ->(type) { where(type: type) }
  scope :ordered, -> { order(created_at: :desc) }
  scope :by_position, -> { order(position: :asc) }

  before_validation :generate_slug, on: :create

  def attempts_count
    Rails.cache.fetch([self, 'attempts_count']) do
      quiz_attempts.count
    end
  end

  def success_rate
    Rails.cache.fetch([self, 'success_rate']) do
      return 0.0 if attempts_count.zero?
      (quiz_attempts.where(correct: true).count.to_f / attempts_count * 100).round(1)
    end
  end

  def self.find_by_subject_type_slug(subject, type, slug)
    visible.find_by(subject: subject, type: type, slug: slug)
  end

  def self.get_questions(type: 'practical', year: nil, subject: 'computer science', question_number: nil)
    query = visible.by_type(type).by_subject(subject)
    query = query.by_year(year) if year.present?
    query = query.find_by(position: question_number) if question_number.present?
    query
  end

  def self.get_practical_questions(subject: 'computer science', type: 'practical', year: nil)
    query = visible.by_type(type).by_subject(subject)
    query = query.by_year(year) if year.present?
    query.ordered
  end

  private

  def generate_slug
    return if slug.present?
    
    base_slug = question.to_s[0..70].parameterize
    self.slug = base_slug
    
    # Add number suffix if slug already exists
    counter = 1
    while self.class.exists?(slug: slug)
      self.slug = "#{base_slug}-#{counter}"
      counter += 1
    end
  end
end 