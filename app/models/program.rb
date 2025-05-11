class Program < ApplicationRecord
  belongs_to :topic, counter_cache: true
  belongs_to :subject, counter_cache: true
  has_many :program_comments, dependent: :destroy
  has_many :program_enrollments, dependent: :destroy
  has_many :enrolled_users, through: :program_enrollments, source: :user
  has_many :prerequisites, class_name: 'ProgramPrerequisite', foreign_key: 'program_id', dependent: :destroy
  has_many :prerequisite_programs, through: :prerequisites, source: :prerequisite_program
  has_many :program_tags, dependent: :destroy
  has_many :tags, through: :program_tags
  has_many :program_ratings, dependent: :destroy
  has_many :rating_users, through: :program_ratings, source: :user
  has_many :program_certificates, dependent: :destroy
  has_many :certified_users, through: :program_certificates, source: :user

  validates :question, presence: true
  validates :solution, presence: true
  validates :slug, presence: true, uniqueness: true
  validates :topic_id, presence: true
  validates :difficulty_level, inclusion: { in: 1..5 }, allow_nil: true
  validates :estimated_duration, numericality: { greater_than: 0 }, allow_nil: true

  scope :visible, -> { where(visible: true) }
  scope :ordered, -> { order(created_at: :desc) }
  scope :by_topic, ->(topic_id) { where(topic_id: topic_id) }
  scope :by_difficulty, ->(level) { where(difficulty_level: level) }
  scope :by_duration, ->(duration) { where('estimated_duration <= ?', duration) }
  scope :with_prerequisites, -> { includes(:prerequisite_programs) }
  scope :popular, -> { joins(:program_enrollments).group('programs.id').order('COUNT(program_enrollments.id) DESC') }

  before_validation :generate_slug, on: :create
  after_save :update_topic_programs_count
  after_destroy :update_topic_programs_count

  def self.find_by_slug(slug)
    visible.find_by(slug: slug)
  end

  def self.related_programs(topic_id, limit: 5)
    visible.by_topic(topic_id).limit(limit)
  end

  def self.by_topics(topic_url_names, limit: nil)
    query = visible.joins(:topic)
      .where(topics: { url_name: topic_url_names, visible: true })
      .includes(:topic)
    
    query = query.limit(limit) if limit.present?
    query
  end

  def enrollment_for(user)
    program_enrollments.find_by(user_id: user.id)
  end

  def enrolled?(user)
    program_enrollments.exists?(user_id: user.id)
  end

  def completed_by?(user)
    program_enrollments.exists?(user_id: user.id, status: 'completed')
  end

  def prerequisites_met?(user)
    prerequisite_programs.all? { |prereq| prereq.completed_by?(user) }
  end

  def enroll(user)
    return false if enrolled?(user)
    return false unless prerequisites_met?(user)

    ProgramEnrollment.enroll(user.id, id)
  end

  def difficulty_label
    case difficulty_level
    when 1 then 'Beginner'
    when 2 then 'Easy'
    when 3 then 'Medium'
    when 4 then 'Hard'
    when 5 then 'Expert'
    end
  end

  def to_param
    slug
  end

  def average_rating
    Rails.cache.fetch([self, 'average_rating']) do
      program_ratings.average(:rating)&.round(1)
    end
  end

  def enrollments_count
    Rails.cache.fetch([self, 'enrollments_count']) do
      program_enrollments.count
    end
  end

  def rating_distribution
    program_ratings.group(:rating).count.transform_keys(&:to_i)
  end

  def verified_ratings_count
    program_ratings.verified.count
  end

  def rating_summary
    {
      average_rating: average_rating,
      total_ratings: program_ratings.count,
      verified_ratings: verified_ratings_count,
      distribution: rating_distribution
    }
  end

  def certificate_for(user)
    program_certificates.find_by(user_id: user.id)
  end

  def has_certificate?(user)
    program_certificates.exists?(user_id: user.id)
  end

  def active_certificates_count
    program_certificates.active.count
  end

  def revoked_certificates_count
    program_certificates.revoked.count
  end

  def expired_certificates_count
    program_certificates.expired.count
  end

  def certificate_stats
    {
      total: program_certificates.count,
      active: active_certificates_count,
      revoked: revoked_certificates_count,
      expired: expired_certificates_count
    }
  end

  private

  def update_topic_programs_count
    topic.reset_programs_count if topic
    subject.reset_programs_count if subject
  end

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