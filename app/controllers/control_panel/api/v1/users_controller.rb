class ControlPanel::API::V1::UsersController < ControlPanel::API::V1::ApplicationController
  skip_before_action :authenticate_user!, only: :create

  BAD_REG = 'registration.email_already_taken_or_bad_password'

  before_action :set_user, only: [:show, :destroy, :update]

  def create
    user = User::Create.(request, params[:invite],
        auth_method: 'email',
        confirmation_token: params[:invite] ? nil : SecureRandom.hex(64),
        confirmation_sent_at: Time.now,
        confirmed_at: params[:invite] ? Time.now : nil,
        **create_user_params.to_h.symbolize_keys
    )

    if params[:invite]
      session[:user_id] = user.id
      render json: user
    elsif params[:plan_id]
      session[:return_to] = "/projects/#{user.projects.first.id}/services/new?plan=#{params[:plan_id]}"
      user.send_verification_email!
      head :created
    else
      user.send_verification_email!
      head :created
    end
  rescue ActiveRecord::RecordInvalid
    render json: {message: BAD_REG}, status: :bad_request
  end

  def show
    render json: @user
  end

  def index
    redirect_to api_v1_user_path(current_user)
  end

  def update
    @user.update!(update_user_params)
    render json: @user
  end

  def destroy
    raise CustomError.new('remove-all-projects') if @user.memberships.where(role: :owner).size > 0
    @user.destroy
    reset_session
    head :no_content
  end

  private

  def create_user_params
    params.permit(:name, :email, :password, :password_confirmation)
  end

  def update_user_params
    params.permit(:name)
  end

  def set_user
    if params[:id] == current_user.id
      @user = current_user
    else
      head :not_found
    end
  end
end
