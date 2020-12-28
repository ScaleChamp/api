class User::Confirm < ServiceObject
  attr_reader :user, :request

  def initialize(user, request)
    @user = user
    @request = request
  end

  def call
    User.transaction do
      user.update!(confirmed_at: Time.now, confirmation_token: nil, auth_method: 'email', **email_params)
      user.security_logs.create!(
          action_type: SecurityLog::EMAIL_CONFIRM,
          remote_ip: request.remote_ip
      )
      user.send_welcome_email!
    end
  end

  private

  def email_params
    return {email: user.unconfirmed_email, unconfirmed_email: nil} if user.unconfirmed_email
    {}
  end
end
