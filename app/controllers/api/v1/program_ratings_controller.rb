module Api
  module V1
    class ProgramRatingsController < ApplicationController
      before_action :authenticate_user!, except: [:index, :show]
      before_action :set_program
      before_action :set_rating, only: [:show, :update, :destroy, :flag, :unflag, :vote_helpful, :vote_unhelpful, :remove_vote]
      before_action :authorize_owner, only: [:update, :destroy]

      def index
        @ratings = @program.program_ratings
          .includes(:user)
          .verified
          .recent
          .page(params[:page])
          .per(params[:per_page] || 10)

        render json: ProgramRatingSerializer.new(@ratings, include: [:user]).serializable_hash
      end

      def show
        render json: ProgramRatingSerializer.new(@rating, include: [:user]).serializable_hash
      end

      def create
        @rating = @program.program_ratings.build(rating_params)
        @rating.user = current_user
        @rating.mark_as_verified

        if @rating.save
          render json: ProgramRatingSerializer.new(@rating).serializable_hash, status: :created
        else
          render json: { errors: @rating.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @rating.update(rating_params)
          render json: ProgramRatingSerializer.new(@rating).serializable_hash
        else
          render json: { errors: @rating.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @rating.destroy
        head :no_content
      end

      def flag
        if @rating.flag
          render json: ProgramRatingSerializer.new(@rating).serializable_hash
        else
          render json: { errors: @rating.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def unflag
        if @rating.unflag
          render json: ProgramRatingSerializer.new(@rating).serializable_hash
        else
          render json: { errors: @rating.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def vote_helpful
        if @rating.vote_helpful(current_user)
          render json: ProgramRatingSerializer.new(@rating).serializable_hash
        else
          render json: { error: 'Unable to vote on this review' }, status: :unprocessable_entity
        end
      end

      def vote_unhelpful
        if @rating.vote_unhelpful(current_user)
          render json: ProgramRatingSerializer.new(@rating).serializable_hash
        else
          render json: { error: 'Unable to vote on this review' }, status: :unprocessable_entity
        end
      end

      def remove_vote
        if @rating.remove_vote(current_user)
          render json: ProgramRatingSerializer.new(@rating).serializable_hash
        else
          render json: { error: 'Unable to remove vote' }, status: :unprocessable_entity
        end
      end

      private

      def set_program
        @program = Program.find(params[:program_id])
      end

      def set_rating
        @rating = @program.program_ratings.find(params[:id])
      end

      def rating_params
        params.require(:program_rating).permit(:rating, :review, metadata: {})
      end

      def authorize_owner
        unless @rating.user_id == current_user.id || current_user.admin?
          render json: { error: 'Not authorized' }, status: :forbidden
        end
      end
    end
  end
end 