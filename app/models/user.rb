class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  enum :role, { user: 0, admin: 1, superadmin: 2 }
  enum :status, { active: 0, inactive: 1, blocked: 2 }

  def self.search(query)
    return all unless query.present?

    where(
      'username ILIKE :query OR email ILIKE :query OR first_name ILIKE :query OR last_name ILIKE :query',
      query: "%#{query}%"
    )
  end

  def generate_jwt
    JWT.encode(
      {
        id: id,
        exp: 60.days.from_now.to_i
      },
      Rails.application.credentials.secret_key_base
    )
  end

  def activate!
    update!(status: :active)
  end

  def deactivate!
    update!(status: :inactive)
  end

  def block!
    update!(status: :blocked)
  end

  def unblock!
    update!(status: :active)
  end
end
