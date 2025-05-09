module Api
  module V1
    class QaAnswersController < ApplicationController
      before_action :authenticate_user!, except: [:index]
      before_action :set_answer, only: [:update, :destroy, :vote]

      def index
        @answers = QaAnswer.visible
          .where(qa_question_id: params[:question_id])
          .includes(:user, :qa_votes)
          .recent
          .page(params[:page])
          .per(20)

        render json: QaAnswerSerializer.new(@answers, include: [:user, :qa_votes]).serializable_hash
      end

      def create
        @answer = current_user.qa_answers.build(answer_params)
        
        if @answer.save
          render json: QaAnswerSerializer.new(@answer).serializable_hash, status: :created
        else
          render json: { errors: @answer.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @answer.user_id == current_user.id && @answer.update(answer_params)
          render json: QaAnswerSerializer.new(@answer).serializable_hash
        else
          render json: { errors: @answer.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        if @answer.user_id == current_user.id
          @answer.update(visible: false)
          head :no_content
        else
          render json: { error: 'Not authorized' }, status: :forbidden
        end
      end

      def vote
        vote = @answer.qa_votes.find_or_initialize_by(user: current_user)
        vote.vote = params[:vote].to_i
        
        if vote.save
          render json: { vote_count: @answer.vote_count }
        else
          render json: { errors: vote.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_answer
        @answer = QaAnswer.find(params[:id])
      end

      def answer_params
        params.require(:qa_answer).permit(:qa_question_id, :answer)
      end
    end
  end
end 