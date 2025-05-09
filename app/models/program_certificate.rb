class ProgramCertificate < ApplicationRecord
  belongs_to :program
  belongs_to :user

  validates :certificate_number, presence: true, uniqueness: true
  validates :verification_code, presence: true, uniqueness: true
  validates :status, presence: true, inclusion: { in: %w[active revoked expired] }
  validates :issued_at, presence: true
  validates :user_id, uniqueness: { scope: :program_id, message: 'already has a certificate for this program' }

  before_validation :generate_certificate_number, on: :create
  before_validation :generate_verification_code, on: :create
  before_validation :set_issued_at, on: :create
  before_validation :set_expires_at, on: :create

  scope :active, -> { where(status: 'active') }
  scope :revoked, -> { where(status: 'revoked') }
  scope :expired, -> { where(status: 'expired') }
  scope :recent, -> { order(issued_at: :desc) }

  def self.generate_certificate_number
    loop do
      number = "CERT-#{Time.current.strftime('%Y%m%d')}-#{SecureRandom.hex(4).upcase}"
      break number unless exists?(certificate_number: number)
    end
  end

  def self.generate_verification_code
    loop do
      code = SecureRandom.hex(8).upcase
      break code unless exists?(verification_code: code)
    end
  end

  def self.verify(verification_code)
    find_by(verification_code: verification_code, status: 'active')
  end

  def revoke
    update(status: 'revoked')
  end

  def expire
    update(status: 'expired')
  end

  def active?
    status == 'active'
  end

  def revoked?
    status == 'revoked'
  end

  def expired?
    status == 'expired' || (expires_at.present? && expires_at < Time.current)
  end

  def verification_url
    Rails.application.routes.url_helpers.verify_api_v1_program_certificate_url(verification_code)
  end

  def to_pdf
    # This will be implemented with a PDF generation service
    # For now, return a placeholder
    {
      certificate_number: certificate_number,
      program_name: program.title,
      user_name: user.full_name,
      issued_at: issued_at,
      expires_at: expires_at,
      verification_code: verification_code
    }
  end

  private

  def generate_certificate_number
    self.certificate_number = self.class.generate_certificate_number
  end

  def generate_verification_code
    self.verification_code = self.class.generate_verification_code
  end

  def set_issued_at
    self.issued_at ||= Time.current
  end

  def set_expires_at
    # Set expiration to 2 years from issue date if not specified
    self.expires_at ||= issued_at + 2.years if issued_at
  end
end 