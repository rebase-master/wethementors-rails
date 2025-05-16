require_relative './v1/users'
require_relative './v1/programs'
require_relative './v1/qa'
require_relative './v1/profile'

module API
  class Base < Grape::API
    prefix 'api'
    version 'v1', using: :path
    format :json

    mount API::V1::Users
    mount API::V1::Programs
    mount API::V1::Qa
    mount API::V1::Profile
  end
end 