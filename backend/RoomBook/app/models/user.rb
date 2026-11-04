class User < ApplicationRecord
  has_secure_password

  enum role: { guest: 0, host: 1 }

  has_many :hotels,   dependent: :destroy
  has_many :bookings, dependent: :destroy
  has_many :reviews,  dependent: :destroy

  normalizes :email, with: ->(email) { email.to_s.strip.downcase }

  validates :email, presence: true,
                    uniqueness: { case_sensitive: false },
                    format: { with: URI::MailTo::EMAIL_REGEXP }
  validates :first_name, presence: true, length: { maximum: 60 }
  validates :last_name, length: { maximum: 60 }, allow_blank: true
  validates :password, length: { minimum: 8 }, allow_nil: true

  before_create :generate_api_token

  def full_name
    [first_name, last_name].compact_blank.join(" ")
  end

  def ensure_api_token!
    update_column(:api_token, SecureRandom.hex(32)) if api_token.blank?
    api_token
  end

  private

  def generate_api_token
    self.api_token ||= SecureRandom.hex(32)
  end
end
