class Topic < ApplicationRecord
  has_many :programs, dependent: :destroy

  validates :topic, :url_name, presence: true
  validates :url_name, uniqueness: true

  scope :visible, -> { where(visible: true) }
  scope :recent, -> { order(created_at: :desc) }

  before_validation :strip_tags

  private

  def strip_tags
    self.topic = ActionController::Base.helpers.strip_tags(topic) if topic.present?
    self.url_name = ActionController::Base.helpers.strip_tags(url_name) if url_name.present?
  end
end
