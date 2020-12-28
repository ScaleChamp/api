class User < ApplicationRecord
  validates :email, format: {with: URI::MailTo::EMAIL_REGEXP}, presence: true, uniqueness: true

  validates :unconfirmed_email, format: {with: URI::MailTo::EMAIL_REGEXP},
            unless: -> { self.unconfirmed_email.blank? },
            uniqueness: {scope: :email}

  validates :auth_method, inclusion: {in: %w(email github google)}

  validates :password, presence: true, unless: -> { self.unconfirmed_email.blank? }

  has_secure_password validations: false

  has_one_time_password

  scope :not_confirmed, -> { where("confirmation_token IS NOT NULL") }

  scope :reset_password_token_exists, -> { where("reset_password_token IS NOT NULL") }

  scope :google, -> { where("google_user_id IS NOT NULL") }

  scope :github, -> { where("github_user_id IS NOT NULL") }

  has_many :memberships

  has_many :projects, through: :memberships

  has_many :security_logs

  def to_json
    UserSerializer.new(self).to_json
  end

  def send_verification_email!
    UserMailer.with(user: self).verify_email.deliver_now
  end

  def verify_unconfirmed_email!
    UserMailer.with(user: self).verify_unconfirmed_email.deliver_now
  end

  def send_welcome_email!
    UserMailer.with(user: self).email_confirmed.deliver_now
  end

  def send_password_reset_email!
    UserMailer.with(user: self).password_reset.deliver_now
  end

  def generate_otp_backup_codes!
    codes = []
    number_of_codes = 10
    code_length = 8

    number_of_codes.times do
      codes << SecureRandom.hex(code_length / 2) # Hexstring has length 2*n
    end

    hashed_codes = codes.map { |code| BCrypt::Password.create(code) }
    self.otp_backup_codes = hashed_codes

    codes
  end

  def invalidate_otp_backup_code!(code)
    codes = self.otp_backup_codes || []

    codes.each do |backup_code|
      next unless BCrypt::Password.new(backup_code) == code

      codes.delete(backup_code)
      self.otp_backup_codes = codes
      return save
    end

    false
  end
end
