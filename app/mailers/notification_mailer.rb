class NotificationMailer < ApplicationMailer
  def notification_email
    @notification = params[:notification]
    @recipient = @notification.recipient
    @actor = @notification.actor
    @data = @notification.data

    mail(
      to: @recipient.email,
      subject: notification_subject
    )
  end

  private

  def notification_subject
    case @notification.type
    when 'CommentNotification'
      "#{@actor.username} commented on your #{@data['commentable_type'].downcase}"
    when 'LikeNotification'
      "#{@actor.username} liked your #{@data['likeable_type'].downcase}"
    when 'FollowNotification'
      "#{@actor.username} started following you"
    when 'ProgramCommentNotification'
      "#{@actor.username} commented on your program"
    when 'ProgramLikeNotification'
      "#{@actor.username} liked your program"
    else
      'New notification'
    end
  end
end 