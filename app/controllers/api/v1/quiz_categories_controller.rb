module Api
  module V1
    class QuizCategoriesController < ApplicationController
      before_action :authenticate_user!, except: [:index, :show]
      before_action :set_category, only: [:show, :high_scores, :progress]

      def index
        @categories = QuizCategory.active.includes(:quiz_questions)
        render json: QuizCategorySerializer.new(@categories).serializable_hash
      end

      def show
        render json: QuizCategorySerializer.new(@category, include: [:quiz_questions]).serializable_hash
      end

      def high_scores
        @scores = @category.high_scores(limit: params[:limit] || 10)
        render json: QuizScoreSerializer.new(@scores, include: [:user]).serializable_hash
      end

      def progress
        @progress = current_user.quiz_progresses.find_or_initialize_by(quiz_category_id: @category.id)
        render json: QuizProgressSerializer.new(@progress).serializable_hash
      end

      def statistics
        @category = QuizCategory.find(params[:id])
        render json: {
          total_questions: @category.quiz_questions.active.count,
          average_score: @category.average_score,
          total_attempts: @category.total_attempts,
          unique_participants: @category.unique_participants,
          difficulty_distribution: difficulty_distribution,
          recent_activity: recent_activity
        }
      end

      private

      def set_category
        @category = QuizCategory.find(params[:id])
      end

      def difficulty_distribution
        @category.quiz_questions.active.group(:difficulty).count.transform_keys do |level|
          case level
          when 1 then 'beginner'
          when 2 then 'easy'
          when 3 then 'medium'
          when 4 then 'hard'
          when 5 then 'expert'
          end
        end
      end

      def recent_activity
        @category.quiz_scores
          .includes(:user)
          .recent
          .limit(5)
          .map do |score|
            {
              user: score.user.username,
              score: score.score,
              percentage: score.percentage_score,
              attempted_at: score.created_at
            }
          end
      end
    end
  end
end 