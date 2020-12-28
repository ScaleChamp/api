class ControlPanel::RegistrationsController < ControlPanel::ApplicationController
  USER_EMAIL_ALREADY_EXISTS = 'user-email-already-exists'
  BAD_REQUEST = 'bad-request'

  def create
    user = User::Create.(request, omniauth_params[:invite],
        "#{auth_hash[:provider]}_user_id".to_sym => auth_hash[:uid],
        :email => auth_hash.dig(:info, :email),
        :name => auth_hash.dig(:info, :name),
        :auth_method => auth_hash[:provider],
        :confirmed_at => Time.now,
        :otp_required_for_login => false
    )
    user.security_logs.create!(action_type: SecurityLog::OAUTH_LOGIN, remote_ip: request.remote_ip)
    session[:user_id] = user.id
    redirect_to projects_or_new_service
  rescue ActiveRecord::RecordNotUnique, ActiveRecord::RecordInvalid
    flash[USER_EMAIL_ALREADY_EXISTS] = 'User email already exists'
    redirect_to register_path
  rescue StandardError => e
    logger.info e
    flash[BAD_REQUEST] = 'Something bad happened!'
    redirect_to register_path
  end

  private

  def projects_or_new_service
    if omniauth_params[:plan_id]
      "/projects/#{user.projects.first.id}/services/new?plan=#{omniauth_params[:plan_id]}"
    else
      '/projects'
    end
  end
end
