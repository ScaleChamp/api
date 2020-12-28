class ControlPanel::API::V1::PasswordsController < ControlPanel::API::V1::ApplicationController
  skip_before_action :authenticate_user!

  PASSWORD_RESET_TOKEN_EXPIRED = 'password-reset-token-expired'

  def create
    user = User.find_by_email!(params[:email])
    User::ResetPassword.(user)
    head :created
  end

  def update
    user = User.reset_password_token_exists.find_by_reset_password_token!(user_params[:id])

    if user.reset_password_sent_at < 30.minutes.ago
      User::ResetPassword.(user)
      render json: {
          message: PASSWORD_RESET_TOKEN_EXPIRED
      }, status: :bad_request # password reset token expired please request one more time
    else
      User::ConfirmPassword.(user, user_params)
      head :no_content
    end
  end

  private

  def user_params
    params.permit(:password, :password_confirmation, :id)
  end
end
