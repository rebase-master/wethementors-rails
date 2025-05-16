class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  enum role: { user: 0, admin: 1, superadmin: 2 }
  enum status: { active: 0, inactive: 1, blocked: 2 }

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
