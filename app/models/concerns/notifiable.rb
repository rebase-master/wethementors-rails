module Notifiable
  extend ActiveSupport::Concern

  included do
    has_many :notifications, as: :recipient, dependent: :destroy
  end

  def unread_notifications_count
    notifications.unread.count
  end

  def mark_all_notifications_as_read!
    notifications.mark_all_as_read!
  end

  def mark_all_notifications_as_unread!
    notifications.mark_all_as_unread!
  end

  def destroy_all_notifications!
    notifications.destroy_all_for_recipient!
  end
end 