class User::ResetPassword < ServiceObject
  attr_reader :user

  def initialize(user)
    @user = user
  end

  def call
    @user.update!(reset_password_token: SecureRandom.hex(32), reset_password_sent_at: Time.now)
    @user.send_password_reset_email!
  end
end
