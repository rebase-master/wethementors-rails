class HomeController < ApplicationController
  def index
    @featured_programs = Program.includes(:topic, :subject)
                              .visible
                              .ordered
                              .limit(6)

    @recent_questions = QaQuestion.includes(:user, :tags)
                                .visible
                                .recent
                                .limit(5)

    @popular_topics = Topic.visible
                          .by_programs_count
                          .limit(8)

    @yearly_questions = YearlyQuestion.includes(:subject)
                                    .visible
                                    .order(year: :desc, created_at: :desc)
                                    .limit(5)

    respond_to do |format|
      format.html
      format.json { render json: {
        featured_programs: @featured_programs,
        recent_questions: @recent_questions,
        popular_topics: @popular_topics,
        yearly_questions: @yearly_questions
      }}
    end
  end
end 