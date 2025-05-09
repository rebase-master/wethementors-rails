module Api
  module V1
    class SubjectsController < ApplicationController
      before_action :authenticate_user!, except: [:index, :show]
      before_action :set_subject, only: [:show, :update, :destroy]

      def index
        @subjects = Subject.visible.ordered.page(params[:page])
        render json: SubjectSerializer.new(@subjects).serializable_hash
      end

      def show
        render json: SubjectSerializer.new(@subject).serializable_hash
      end

      def create
        @subject = Subject.new(subject_params)
        
        if @subject.save
          render json: SubjectSerializer.new(@subject).serializable_hash, status: :created
        else
          render json: { errors: @subject.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @subject.update(subject_params)
          render json: SubjectSerializer.new(@subject).serializable_hash
        else
          render json: { errors: @subject.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        if @subject.destroy
          head :no_content
        else
          render json: { errors: @subject.errors }, status: :unprocessable_entity
        end
      end

      private

      def set_subject
        @subject = if params[:url_name]
          Subject.find_by_url_name(params[:url_name])
        else
          Subject.find(params[:id])
        end
      end

      def subject_params
        params.require(:subject).permit(:name, :url_name, :visible)
      end
    end
  end
end 