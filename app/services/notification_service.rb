class NotificationService
  def self.notify(recipient:, actor: nil, type:, data: {})
    notification = Notification.create!(
      recipient: recipient,
      actor: actor,
      type: type,
      data: data
    )

    # Send email notification if recipient has email notifications enabled
    if recipient.respond_to?(:email_notifications_enabled?) && recipient.email_notifications_enabled?
      NotificationMailer.with(notification: notification).notification_email.deliver_later
      notification.mark_email_sent!
    end

    notification
  end

  def self.notify_all(recipients:, actor: nil, type:, data: {})
    recipients.each do |recipient|
      notify(recipient: recipient, actor: actor, type: type, data: data)
    end
  end
end 