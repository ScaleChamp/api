class ControlPanel::LoginsController < ControlPanel::ApplicationController
  USER_EMAIL_ALREADY_EXISTS = 'user-email-already-exists'
  BAD_REQUEST = 'bad-request'

  def create
    current_user.update!(
        "#{auth_hash[:provider]}_user_id".to_sym => auth_hash[:uid],
        :email => auth_hash.dig(:info, :email),
        :auth_method => auth_hash[:provider],
        :confirmed_at => Time.now,
        :otp_required_for_login => false)

    current_user.security_logs.create!(action_type: SecurityLog::AUTH_METHOD_UPDATE, remote_ip: request.remote_ip)
    session[:user_id] = user.id
  rescue ActiveRecord::RecordNotUnique
    flash[USER_EMAIL_ALREADY_EXISTS] = 'User email already exists!'
  rescue
    flash[BAD_REQUEST] = 'Something bad happened!'
  ensure
    redirect_to profile_path
  end
end
