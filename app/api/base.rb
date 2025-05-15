require_relative './v1/users'

module API
  class Base < Grape::API
    prefix 'api'
    version 'v1', using: :path
    format :json

    mount API::V1::Users
  end
end 