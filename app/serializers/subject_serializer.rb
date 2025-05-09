class SubjectSerializer
  include JSONAPI::Serializer

  attributes :name,
             :url_name,
             :visible,
             :created_at,
             :updated_at

  attribute :yearly_questions_count do |subject|
    subject.yearly_questions.visible.count
  end

  attribute :url do |subject|
    Rails.application.routes.url_helpers.api_v1_subject_path(subject.url_name)
  end
end 