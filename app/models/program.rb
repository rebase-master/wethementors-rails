class Program < ApplicationRecord
  belongs_to :topic
  has_many :program_comments, dependent: :destroy

  validates :slug, presence: true, uniqueness: true
  validates :question, :solution, presence: true

  scope :visible, -> { where(visible: true) }
  scope :by_topic, ->(topic_id) { where(topic_id: topic_id) }
  scope :recent, -> { order(created_at: :desc) }

  def related_programs(limit = 5)
    self.class.visible.by_topic(topic_id).where.not(id: id).limit(limit)
  end
end
