class Quote < ApplicationRecord
  validates :quote, presence: true
  validates :slug, presence: true, uniqueness: true

  scope :visible, -> { where(visible: true) }

  before_validation :generate_slug, on: :create

  private

  def generate_slug
    return if slug.present?
    
    base_slug = quote.to_s[0..70].parameterize
    self.slug = base_slug
    
    # Add number suffix if slug already exists
    counter = 1
    while self.class.exists?(slug: slug)
      self.slug = "#{base_slug}-#{counter}"
      counter += 1
    end
  end
end 