class YearlyQuestionSerializer
  include JSONAPI::Serializer

  attributes :year,
             :subject,
             :type,
             :position,
             :slug,
             :heading,
             :question,
             :solution,
             :visible,
             :created_at,
             :updated_at

  attribute :url do |question|
    Rails.application.routes.url_helpers.api_v1_yearly_question_path(
      subject: question.subject,
      type: question.type,
      slug: question.slug
    )
  end
end 