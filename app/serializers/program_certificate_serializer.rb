class ProgramCertificateSerializer
  include JSONAPI::Serializer

  attributes :certificate_number,
             :verification_code,
             :issued_at,
             :expires_at,
             :status,
             :achievement_data,
             :verification_url

  attribute :is_expired do |certificate|
    certificate.expired?
  end

  attribute :is_revoked do |certificate|
    certificate.revoked?
  end

  attribute :is_valid do |certificate|
    certificate.valid?
  end

  belongs_to :program
  belongs_to :user
end 