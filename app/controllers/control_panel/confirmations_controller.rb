class ControlPanel::ConfirmationsController < ControlPanel::ApplicationController
  skip_before_action :authenticate_user

  VERIFICATION_LINK_EXPIRED = 'verification-link-expired'

  VERIFICATION_LINK_INCORRECT = 'verification-link-incorrect'

  def show
    user = User.not_confirmed.find_by_confirmation_token!(params[:id])

    if user.confirmation_sent_at < 1.hour.ago
      User::Reconfirm.(user, request)
      flash[VERIFICATION_LINK_EXPIRED] = "Verification link expired. Please recheck email inbox"
      redirect_to login_path
    else
      User::Confirm.(user, request)
      session[:user_id] = user.id
      if session[:return_to]
        return_to = session[:return_to]
        session[:return_to] = nil
        redirect_to return_to
      else
        redirect_to root_path
      end
    end
  rescue ActiveRecord::RecordNotFound
    flash[VERIFICATION_LINK_INCORRECT] = "Verification link incorrect."
    redirect_to login_path
  end
end
