class ControlPanel::API::V1::LoginsController < ControlPanel::API::V1::ApplicationController
  def create
    current_user.unconfirmed_email = params[:email]
    current_user.password = params[:password]
    current_user.password_confirmation = params[:password]
    current_user.confirmation_sent_at = Time.now
    current_user.confirmation_token = SecureRandom.hex(28)
    current_user.save!
    current_user.verify_unconfirmed_email!
    render json: current_user
  end
end
