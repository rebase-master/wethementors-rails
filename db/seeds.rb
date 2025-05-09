# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Create default profile options
ProfileOption.create!([
  {
    name: 'Display Picture',
    options: 'display_picture',
    description: 'User profile picture',
    required: true,
    public: true
  },
  {
    name: 'Bio',
    options: 'bio',
    description: 'User biography',
    required: false,
    public: true
  },
  {
    name: 'Location',
    options: 'location',
    description: 'User location',
    required: false,
    public: true
  },
  {
    name: 'Website',
    options: 'website',
    description: 'User website',
    required: false,
    public: true
  },
  {
    name: 'Social Links',
    options: 'social_links',
    description: 'User social media links',
    required: false,
    public: true
  }
])

# Create admin user
User.create!(
  email: 'admin@wethementors.com',
  username: 'admin',
  password: 'changeme123',
  password_confirmation: 'changeme123',
  first_name: 'Admin',
  last_name: 'User',
  admin: true,
  confirmed: true
)
