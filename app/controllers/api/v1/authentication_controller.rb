module Api
  module V1
    class AuthenticationController < ApplicationController
      skip_before_action :authenticate_user!, only: [:create]

      def create
        user = User.find_by(email: params[:email])
        if user&.valid_password?(params[:password])
          render json: {
            token: request.env['warden-jwt_auth.token'],
            user: user.as_json(only: [:id, :email, :username, :admin])
          }
        else
          render json: { error: 'Invalid email or password' }, status: :unauthorized
        end
      end

      def destroy
        current_user.jwt_denylist.create!(
          jti: request.env['warden-jwt_auth.token'],
          exp: Time.at(request.env['warden-jwt_auth.payload']['exp'])
        )
        head :no_content
      end
    end
  end
end 