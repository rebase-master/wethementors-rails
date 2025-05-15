module API
  module V1
    class Users < Grape::API
      resource :users do
        desc 'Return a list of users'
        get do
          User.all
        end

        desc 'Return a specific user'
        params do
          requires :id, type: Integer, desc: 'User ID'
        end
        route_param :id do
          get do
            User.find(params[:id])
          end
        end
      end
    end
  end
end 