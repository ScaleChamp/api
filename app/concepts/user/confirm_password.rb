class User::ConfirmPassword < ServiceObject
  attr_reader :user, :user_params

  def initialize(user, user_params)
    @user = user
    @user_params = user_params
  end

  def call
    @user.update!(
        reset_password_token: nil,
        reset_password_sent_at: nil,
        password: user_params[:password],
        password_confirmation: user_params[:password_confirmation]
    )
  end
end
