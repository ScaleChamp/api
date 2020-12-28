class ControlPanel::API::V1::OtpController < ControlPanel::API::V1::ApplicationController
  before_action :ensure_email_method_used
  before_action :validate_otp, only: :confirm

  def enable
    current_user.otp_regenerate_secret
    provisioning_uri = current_user.provisioning_uri(nil, issuer: 'scalechamp.com') # ScaleChamp.name
    current_user.save!
    response.set_header(ActionDispatch::Response::LOCATION, current_user.otp_column)
    render json: provisioning_uri
  end

  def confirm
    codes = current_user.generate_otp_backup_codes!
    current_user.otp_required_for_login = true
    current_user.save!
    response.set_header(ActionDispatch::Response::LOCATION, codes.join(','))
    render json: current_user
  end

  def recovery_codes
    codes = current_user.generate_otp_backup_codes!
    current_user.save!
    render json: codes
  end

  def disable
    current_user.update!(otp_required_for_login: false)
    render json: current_user
  end

  private

  def validate_otp
    raise CustomError.new('code-invalid') unless current_user.authenticate_otp(params[:code])
  end

  def ensure_email_method_used
    head :bad_request unless current_user.auth_method == 'email'
  end
end
