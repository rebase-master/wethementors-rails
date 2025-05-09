module Api
  module V1
    class ProgramCommentsController < ApplicationController
      before_action :authenticate_user!, except: [:index]
      before_action :set_comment, only: [:update, :destroy, :flag, :unflag]

      def index
        @comments = if params[:program_id]
          ProgramComment.for_program(params[:program_id], page: params[:page])
        elsif params[:user_id]
          ProgramComment.by_user(params[:user_id], page: params[:page])
        else
          ProgramComment.active.includes(:user, :program).recent.page(params[:page])
        end

        render json: ProgramCommentSerializer.new(@comments, include: [:user, :program]).serializable_hash
      end

      def create
        @comment = current_user.program_comments.build(comment_params)
        
        if @comment.save
          render json: ProgramCommentSerializer.new(@comment).serializable_hash, status: :created
        else
          render json: { errors: @comment.errors }, status: :unprocessable_entity
        end
      end

      def update
        if @comment.user_id == current_user.id && @comment.update(comment_params)
          render json: ProgramCommentSerializer.new(@comment).serializable_hash
        else
          render json: { errors: @comment.errors }, status: :unprocessable_entity
        end
      end

      def destroy
        if @comment.user_id == current_user.id || current_user.admin?
          @comment.soft_delete
          head :no_content
        else
          render json: { error: 'Not authorized' }, status: :forbidden
        end
      end

      def flag
        if @comment.update(flagged: true)
          render json: ProgramCommentSerializer.new(@comment).serializable_hash
        else
          render json: { errors: @comment.errors }, status: :unprocessable_entity
        end
      end

      def unflag
        if current_user.admin? && @comment.update(flagged: false)
          render json: ProgramCommentSerializer.new(@comment).serializable_hash
        else
          render json: { error: 'Not authorized' }, status: :forbidden
        end
      end

      private

      def set_comment
        @comment = ProgramComment.find(params[:id])
      end

      def comment_params
        params.require(:program_comment).permit(:program_id, :comment)
      end
    end
  end
end 