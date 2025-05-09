class NotificationSerializer
  include JSONAPI::Serializer

  attributes :type,
             :data,
             :read_at,
             :email_sent,
             :created_at,
             :updated_at

  attribute :read do |notification|
    notification.read?
  end

  attribute :actor do |notification|
    if notification.actor
      {
        id: notification.actor.id,
        type: notification.actor.class.name,
        name: notification.actor.try(:name) || notification.actor.try(:username)
      }
    end
  end

  attribute :recipient do |notification|
    {
      id: notification.recipient.id,
      type: notification.recipient.class.name,
      name: notification.recipient.try(:name) || notification.recipient.try(:username)
    }
  end
end 