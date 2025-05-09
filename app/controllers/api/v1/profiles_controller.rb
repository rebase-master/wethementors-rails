module Api
  module V1
    class ProfilesController < ApplicationController
      before_action :authenticate_user!
      before_action :set_user_data, only: [:update, :destroy]

      def show
        render json: {
          profile: current_user.profile,
          user: {
            id: current_user.id,
            email: current_user.email,
            username: current_user.username,
            first_name: current_user.first_name,
            last_name: current_user.last_name,
            gender: current_user.gender,
            created_at: current_user.created_at
          }
        }
      end

      def update
        if @user_data.update(user_data_params)
          render json: { message: 'Profile updated successfully', data: @user_data }
        else
          render json: { errors: @user_data.errors.full_messages }, status: :unprocessable_entity
        end
      end

      def destroy
        @user_data.destroy
        render json: { message: 'Profile data removed successfully' }
      end

      private

      def set_user_data
        @user_data = current_user.user_data.find_by(profile_option_id: params[:profile_option_id])
        render json: { error: 'Profile data not found' }, status: :not_found unless @user_data
      end

      def user_data_params
        params.require(:user_data).permit(:data)
      end
    end
  end
end 