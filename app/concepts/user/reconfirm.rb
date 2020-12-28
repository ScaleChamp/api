class User::Reconfirm < ServiceObject
  attr_reader :user, :request

  def initialize(user, request)
    @user = user
    @request = request
  end

  def call
    User.transaction do
      user.update!(confirmation_token: SecureRandom.hex(64), confirmation_sent_at: Time.now)
      user.security_logs.create!(
          action_type: SecurityLog::EMAIL_RECONFIRM,
          remote_ip: request.remote_ip
      )
      user.send_verification_email!
    end
  end
end
