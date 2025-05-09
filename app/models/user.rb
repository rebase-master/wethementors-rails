class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :jwt_authenticatable, jwt_revocation_strategy: JwtDenylist

  has_one :user_data, dependent: :destroy
  has_many :program_comments, dependent: :destroy
  has_many :yearly_question_comments, dependent: :destroy
  has_many :qa_questions, dependent: :destroy
  has_many :qa_answers, dependent: :destroy
  has_many :qa_votes, dependent: :destroy
  has_many :quiz_scores, dependent: :destroy
  has_many :java_quiz_scores, dependent: :destroy

  validates :email, presence: true, uniqueness: true, format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :username, presence: true, uniqueness: true
  validates :first_name, presence: true
  validates :last_name, presence: true
  validates :gender, presence: true, inclusion: { in: %w[male female other] }

  before_save :normalize_gender

  scope :confirmed, -> { where(confirmed: true) }
  scope :unconfirmed, -> { where(confirmed: false) }
  scope :admins, -> { where(admin: true) }
  scope :blocked, -> { where(blocked: true) }
  scope :active, -> { where(blocked: false) }
  scope :weekly_absentees, -> { confirmed.where('last_login < ?', 7.days.ago) }

  def full_name
    "#{first_name} #{last_name}"
  end

  def profile
    user_data&.data || {}
  end

  def confirm_registration
    update(confirmed: true)
  end

  def block!
    update(blocked: true)
  end

  def unblock!
    update(blocked: false)
  end

  def generate_access_token
    token = SecureRandom.hex(32)
    update(access_token: token)
    token
  end

  private

  def normalize_gender
    self.gender = gender.downcase if gender.present?
  end
end 