module Api
  module V1
    class QaQuestionsController < ApplicationController
      before_action :authenticate_user!, except: [:index, :show]
      before_action :set_question, only: [:show, :update, :destroy, :vote]

      def index
        @questions = QaQuestion.visible.includes(:user, :qa_answers)
        
        case params[:filter]
        when 'popular'
          @questions = @questions.popular
        when 'unanswered'
          @questions = @questions.unanswered
        when 'tag'
          @questions = @questions.with_tag(params[:tag]) if params[:tag].present?
        else
          @questions = @questions.recent
        end

        @questions = @questions.page(params[:page]).per(20)
        render json: QaQuestionSerializer.new(@questions, include: [:user, :qa_answers]).serializable_hash
      end

      def show
        @question = QaQuestion.includes(:user, :qa_answers, :qa_votes).find(params[:id])
        render json: QaQuestionSerializer.new(@question, include: [:user, :qa_answers, :qa_votes]).serializable_hash
      end

      def create
        @question = current_user.qa_questions.build(question_params)
        
        if @question.save
          render json: QaQuestionSerializer.new(@question).serializable_hash, status: :created
        else
          render json: { errors: @question.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @question.user_id == current_user.id && @question.update(question_params)
          render json: QaQuestionSerializer.new(@question).serializable_hash
        else
          render json: { errors: @question.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        if @question.user_id == current_user.id
          @question.update(visible: false)
          head :no_content
        else
          render json: { error: 'Not authorized' }, status: :forbidden
        end
      end

      def vote
        vote = @question.qa_votes.find_or_initialize_by(user: current_user)
        vote.vote = params[:vote].to_i
        
        if vote.save
          render json: { vote_count: @question.vote_count }
        else
          render json: { errors: vote.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_question
        @question = QaQuestion.find(params[:id])
      end

      def question_params
        params.require(:qa_question).permit(:topic, :tags, :question, :description)
      end
    end
  end
end 