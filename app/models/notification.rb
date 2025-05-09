class Notification < ApplicationRecord
  belongs_to :recipient, polymorphic: true
  belongs_to :actor, polymorphic: true, optional: true

  validates :type, presence: true
  validates :data, presence: true

  scope :unread, -> { where(read_at: nil) }
  scope :read, -> { where.not(read_at: nil) }
  scope :email_pending, -> { where(email_sent: false) }
  scope :ordered, -> { order(created_at: :desc) }

  def read?
    read_at.present?
  end

  def mark_as_read!
    update!(read_at: Time.current)
  end

  def mark_as_unread!
    update!(read_at: nil)
  end

  def mark_email_sent!
    update!(email_sent: true)
  end

  def self.mark_all_as_read!(recipient)
    where(recipient: recipient, read_at: nil)
      .update_all(read_at: Time.current)
  end

  def self.mark_all_as_unread!(recipient)
    where(recipient: recipient)
      .update_all(read_at: nil)
  end

  def self.destroy_all_for_recipient!(recipient)
    where(recipient: recipient).destroy_all
  end
end 