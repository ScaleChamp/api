class ControlPanel::API::V1::SessionsController < ControlPanel::API::V1::ApplicationController
  USER_METHOD_NOT_FOUND = 'user-method-not-found'

  skip_before_action :authenticate_user!

  EMAIL_OR_PASSWORD_DOESNT_MATCH = 'email-or-password-doesnt-match'

  after_action :remove_return_to, only: :create

  def create
    user = User.find_by_email!(params[:email])

    if user.auth_method != 'email'
      user.security_logs.create!(action_type: SecurityLog::NOT_EMAIL_FAILURE,
                                 remote_ip: request.remote_ip)
      render json: {
          message: SecurityLog::NOT_EMAIL_FAILURE
      }, status: :not_found
    elsif not user.confirmed_at
      user.security_logs.create!(action_type: SecurityLog::USER_NOT_CONFIRMED,
                                 remote_ip: request.remote_ip)
      render json: {
          message: SecurityLog::USER_NOT_CONFIRMED
      }, status: :bad_request
    elsif user.authenticate(params[:password]) and user.confirmed_at
      if user.otp_required_for_login
        if params.has_key?(:code)
          if user.authenticate_otp(params[:code])
            session[:user_id] = user.id
            render json: user
          elsif user.invalidate_otp_backup_code!(params[:code])
            session[:user_id] = user.id
            render json: user
          else
            render json: {
                message: EMAIL_OR_PASSWORD_DOESNT_MATCH
            }, status: :bad_request # email or password doesn't match
          end
        else
          user.security_logs.create!(action_type: SecurityLog::TFA_OTP_START, remote_ip: request.remote_ip)
          head :accepted
        end
      else
        session[:user_id] = user.id
        user.security_logs.create!(action_type: SecurityLog::LOGIN_SUCCESS, remote_ip: request.remote_ip)
        response.set_header(ActionDispatch::Response::LOCATION, session[:return_to]) unless session[:return_to].blank?
        render json: user
      end
    else
      user.security_logs.create!(action_type: SecurityLog::LOGIN_FAILURE, remote_ip: request.remote_ip)
      render json: {
          message: EMAIL_OR_PASSWORD_DOESNT_MATCH
      }, status: :bad_request # email or password doesn't match
    end
  rescue ActiveRecord::RecordNotFound
    render json: {
        message: USER_METHOD_NOT_FOUND
    }, status: :not_found
  end

  private

  def remove_return_to
    session[:return_to] = nil
  end
end
