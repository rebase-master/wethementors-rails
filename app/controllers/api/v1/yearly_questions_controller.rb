module Api
  module V1
    class YearlyQuestionsController < ApplicationController
      before_action :authenticate_user!, except: [:index, :show]
      before_action :set_question, only: [:show, :update, :destroy]

      def index
        @questions = YearlyQuestion.visible
          .by_type(params[:type])
          .by_year(params[:year])
          .by_subject(params[:subject])
          .by_position
          .page(params[:page])

        render json: YearlyQuestionSerializer.new(@questions, include: [:subject]).serializable_hash
      end

      def show
        render json: YearlyQuestionSerializer.new(@question).serializable_hash
      end

      def create
        @question = YearlyQuestion.new(question_params)
        
        if @question.save
          render json: YearlyQuestionSerializer.new(@question).serializable_hash, status: :created
        else
          render json: { errors: @question.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @question.update(question_params)
          render json: YearlyQuestionSerializer.new(@question).serializable_hash
        else
          render json: { errors: @question.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        @question.update(visible: false)
        head :no_content
      end

      private

      def set_question
        @question = if params[:slug]
          YearlyQuestion.find_by_subject_type_slug(params[:subject], params[:type], params[:slug])
        else
          YearlyQuestion.find(params[:id])
        end
      end

      def question_params
        params.require(:yearly_question).permit(
          :year,
          :subject,
          :type,
          :position,
          :heading,
          :question,
          :solution,
          :visible
        )
      end
    end
  end
end 