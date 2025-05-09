class TopicSerializer
  include JSONAPI::Serializer

  attributes :name,
             :url_name,
             :visible,
             :created_at,
             :updated_at

  attribute :programs_count do |topic|
    topic.programs.visible.count
  end

  attribute :url do |topic|
    Rails.application.routes.url_helpers.api_v1_topic_path(topic.url_name)
  end
end 