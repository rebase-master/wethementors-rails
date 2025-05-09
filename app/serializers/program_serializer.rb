class ProgramSerializer
  include JSONAPI::Serializer

  attributes :heading,
             :slug,
             :question,
             :solution,
             :visible,
             :created_at,
             :updated_at

  attribute :topic do |program|
    {
      id: program.topic.id,
      name: program.topic.name,
      url_name: program.topic.url_name
    }
  end

  attribute :comments_count do |program|
    program.program_comments.visible.count
  end

  attribute :url do |program|
    Rails.application.routes.url_helpers.api_v1_program_path(program.slug)
  end
end 