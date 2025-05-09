module Api
  module V1
    class ProfileOptionsController < ApplicationController
      before_action :authenticate_user!
      before_action :set_profile_option, only: [:show, :update, :destroy]
      before_action :authorize_admin, except: [:index, :show]

      def index
        @profile_options = ProfileOption.all
        render json: @profile_options
      end

      def show
        render json: @profile_option
      end

      def create
        @profile_option = ProfileOption.new(profile_option_params)
        if @profile_option.save
          render json: @profile_option, status: :created
        else
          render json: { errors: @profile_option.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def update
        if @profile_option.update(profile_option_params)
          render json: @profile_option
        else
          render json: { errors: @profile_option.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @profile_option.destroy
        render json: { message: 'Profile option deleted successfully' }
      end

      private

      def set_profile_option
        @profile_option = ProfileOption.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Profile option not found' }, status: :not_found
      end

      def profile_option_params
        params.require(:profile_option).permit(:name, :options, :required, :public)
      end

      def authorize_admin
        unless current_user.admin?
          render json: { error: 'Unauthorized' }, status: :forbidden
        end
      end
    end
  end
end 