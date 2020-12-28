class ControlPanel::SessionsController < ControlPanel::ApplicationController
  USER_METHOD_NOT_FOUND = 'user-method-not-found'
  BAD_FAILURE = 'bad-request'

  after_action :remove_return_to, only: :create

  def create
    user = User.find_by!("#{auth_hash[:provider]}_user_id".to_sym => auth_hash[:uid])
    if user.auth_method != auth_hash[:provider]
      user.security_logs.create!(
          action_type: SecurityLog::LOGIN_NOT_THIS,
          remote_ip: request.remote_ip
      )
      flash[USER_METHOD_NOT_FOUND] = "An account with this sign in provider was not found."
      redirect_to login_path
    else
      user.security_logs.create!(
          action_type: SecurityLog::OAUTH_LOGIN,
          remote_ip: request.remote_ip
      )
      session[:user_id] = user.id
      redirect_to session[:return_to].blank? ? root_path : session[:return_to]
    end
  rescue ActiveRecord::RecordNotFound
    flash[USER_METHOD_NOT_FOUND] = "User with such authentication not found."
    redirect_to login_path
  rescue
    flash[BAD_FAILURE] = "Smth bad happened."
    redirect_to login_path
  end

  def destroy
    reset_session
    redirect_to login_path
  end

  private

  def remove_return_to
    session[:return_to] = nil
  end
end
