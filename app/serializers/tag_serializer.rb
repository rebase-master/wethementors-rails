class TagSerializer
  include JSONAPI::Serializer

  attributes :name,
             :created_at,
             :updated_at

  attribute :programs_count do |tag|
    tag.programs.visible.count
  end

  attribute :yearly_questions_count do |tag|
    tag.yearly_questions.visible.count
  end

  attribute :url do |tag|
    Rails.application.routes.url_helpers.api_v1_tag_path(tag.name)
  end
end 