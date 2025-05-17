module API
  module V1
    class Users < Grape::API
      helpers do
        def authenticate!
          error!('Unauthorized', 401) unless current_user
        end

        def current_user
          @current_user ||= begin
            header = headers['Authorization']
            if header && header.start_with?('Bearer ')
              token = header.split(' ').last
              begin
                decoded = JWT.decode(token, Rails.application.credentials.secret_key_base)[0]
                User.find(decoded['id'])
              rescue JWT::DecodeError, ActiveRecord::RecordNotFound
                nil
              end
            end
          end
        end

        def authorize_admin!
          error!('Forbidden', 403) unless current_user&.admin? || current_user&.superadmin?
        end

        def user_params
          ActionController::Parameters.new(params).permit(
            :email, :username, :password, :password_confirmation,
            :first_name, :last_name, :bio, :avatar
          )
        end
      end

      resource :users do
        desc 'Return a list of users'
        params do
          optional :page, type: Integer, default: 1
          optional :per_page, type: Integer, default: 30
          optional :search, type: String, desc: 'Search term for users'
        end
        get do
          users = User.all
          users = users.search(params[:search]) if params[:search].present?
          users = users.page(params[:page]).per(params[:per_page])
          
          {
            users: users,
            total_count: users.total_count,
            total_pages: users.total_pages,
            current_page: users.current_page
          }
        end

        desc 'Create a new user'
        params do
          requires :email, type: String, desc: 'User email'
          requires :username, type: String, desc: 'Username'
          requires :password, type: String, desc: 'Password'
          requires :password_confirmation, type: String, desc: 'Password confirmation'
          optional :first_name, type: String, desc: 'First name'
          optional :last_name, type: String, desc: 'Last name'
          optional :bio, type: String, desc: 'User bio'
          optional :avatar, type: File, desc: 'User avatar'
        end
        post do
          user = User.new(user_params)
          if user.save
            status 201
            { status: 'success', user: user }
          else
            status 422
            { status: 'error', errors: user.errors.full_messages }
          end
        end

        desc 'Return a specific user'
        params do
          requires :id, type: Integer, desc: 'User ID'
        end
        route_param :id do
          get do
            user = User.find(params[:id])
            { status: 'success', user: user }
          rescue ActiveRecord::RecordNotFound
            error!({ status: 'error', message: 'User not found' }, 404)
          end

          desc 'Update a user'
          params do
            optional :email, type: String, desc: 'User email'
            optional :username, type: String, desc: 'Username'
            optional :password, type: String, desc: 'Password'
            optional :password_confirmation, type: String, desc: 'Password confirmation'
            optional :first_name, type: String, desc: 'First name'
            optional :last_name, type: String, desc: 'Last name'
            optional :bio, type: String, desc: 'User bio'
            optional :avatar, type: File, desc: 'User avatar'
          end
          put do
            authenticate!
            user = User.find(params[:id])
            if user.update(user_params)
              { status: 'success', user: user }
            else
              status 422
              { status: 'error', errors: user.errors.full_messages }
            end
          rescue ActiveRecord::RecordNotFound
            error!({ status: 'error', message: 'User not found' }, 404)
          end

          desc 'Delete a user'
          delete do
            authenticate!
            user = User.find(params[:id])
            if user.destroy
              { status: 'success', message: 'User has been deleted.' }
            else
              status 422
              { status: 'error', errors: user.errors.full_messages }
            end
          rescue ActiveRecord::RecordNotFound
            error!({ status: 'error', message: 'User not found' }, 404)
          end

          desc 'Block a user'
          post :block do
            authenticate!
            authorize_admin!
            user = User.find(params[:id])
            if user.block!
              { status: 'success', message: 'User has been blocked.' }
            else
              status 422
              { status: 'error', errors: user.errors.full_messages }
            end
          rescue ActiveRecord::RecordNotFound
            error!({ status: 'error', message: 'User not found' }, 404)
          end

          desc 'Unblock a user'
          post :unblock do
            authenticate!
            authorize_admin!
            user = User.find(params[:id])
            if user.unblock!
              { status: 'success', message: 'User has been unblocked.' }
            else
              status 422
              { status: 'error', errors: user.errors.full_messages }
            end
          rescue ActiveRecord::RecordNotFound
            error!({ status: 'error', message: 'User not found' }, 404)
          end

          desc 'Verify a user'
          post :verify do
            authenticate!
            authorize_admin!
            user = User.find(params[:id])
            if user.update(confirmed: true)
              { status: 'success', message: 'User has been verified.' }
            else
              status 422
              { status: 'error', errors: user.errors.full_messages }
            end
          rescue ActiveRecord::RecordNotFound
            error!({ status: 'error', message: 'User not found' }, 404)
          end

          desc 'Unverify a user'
          post :unverify do
            authenticate!
            authorize_admin!
            user = User.find(params[:id])
            if user.update(confirmed: false)
              { status: 'success', message: 'User has been unverified.' }
            else
              status 422
              { status: 'error', errors: user.errors.full_messages }
            end
          rescue ActiveRecord::RecordNotFound
            error!({ status: 'error', message: 'User not found' }, 404)
          end
        end

        desc 'Check if username exists'
        params do
          requires :username, type: String, desc: 'Username to check'
        end
        get :check_username do
          exists = User.exists?(username: params[:username])
          { exists: exists }
        end

        desc 'Check if email exists'
        params do
          requires :email, type: String, desc: 'Email to check'
        end
        get :check_email do
          exists = User.exists?(email: params[:email])
          { exists: exists }
        end
      end
    end
  end
end 