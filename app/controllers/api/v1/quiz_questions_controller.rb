module Api
  module V1
    class QuizQuestionsController < ApplicationController
      before_action :authenticate_user!, except: [:index]
      before_action :set_category, only: [:index, :submit]
      before_action :validate_time_limit, only: [:submit]

      def index
        @questions = QuizQuestion.random_questions(
          @category.id,
          count: params[:count] || 10,
          difficulty: params[:difficulty]
        )
        render json: QuizQuestionSerializer.new(@questions).serializable_hash
      end

      def submit
        answers = params[:answers] || {}
        score = 0
        question_answers = {}
        start_time = params[:start_time].to_i
        end_time = Time.current.to_i

        @category.quiz_questions.active.find_each do |question|
          if question.check_answer(answers[question.id.to_s])
            score += 1
          end
          question_answers[question.id] = {
            selected: answers[question.id.to_s],
            correct: question.correct_option,
            time_taken: end_time - start_time
          }
        end

        @score = QuizScore.save_score(@category.id, current_user.id, score, question_answers)
        @progress = QuizProgress.update_progress(@category.id, current_user.id, score, @questions.count)

        render json: {
          score: QuizScoreSerializer.new(@score).serializable_hash,
          progress: QuizProgressSerializer.new(@progress).serializable_hash,
          feedback: generate_feedback(score, @questions.count)
        }
      end

      private

      def set_category
        @category = QuizCategory.find(params[:quiz_category_id])
      end

      def validate_time_limit
        start_time = params[:start_time].to_i
        time_taken = Time.current.to_i - start_time
        max_time = 600 # 10 minutes in seconds

        if time_taken > max_time
          render json: { error: 'Time limit exceeded' }, status: :unprocessable_entity
        end
      end

      def generate_feedback(score, total_questions)
        percentage = (score.to_f / total_questions * 100).round(2)
        
        case percentage
        when 0..40
          {
            message: 'Keep practicing! You\'re just getting started.',
            suggestions: ['Review the basic concepts', 'Take more practice quizzes']
          }
        when 41..60
          {
            message: 'Good effort! You\'re making progress.',
            suggestions: ['Focus on your weak areas', 'Try different difficulty levels']
          }
        when 61..80
          {
            message: 'Great job! You\'re mastering the content.',
            suggestions: ['Challenge yourself with harder questions', 'Help others learn']
          }
        else
          {
            message: 'Excellent! You\'re an expert!',
            suggestions: ['Try teaching others', 'Create your own quiz questions']
          }
        end
      end
    end
  end
end 