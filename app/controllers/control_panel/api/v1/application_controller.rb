class ControlPanel::API::V1::ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  before_action :authenticate_user!

  include FormAuthenticityToken
  include Rails::Pagination
  include Pundit

  def pundit_params_for(record)
    params
  end

  attr_reader :current_user, :pundit_user

  rescue_from CustomError, with: :show_message
  rescue_from AccessDenied, with: :deny_access
  rescue_from Pundit::NotAuthorizedError, with: :not_authorized_error

  private

  def show_message(exception)
    render json: {message: exception.message}, status: 400
  end

  def deny_access(exception)
    render json: {message: exception.message}, status: 401
  end

  def not_authorized_error(exception)
    render json: {message: exception.message}, status: 403
  end

  def authenticate_user!
    @current_user = User.find(session[:user_id])
  rescue
    reset_session
    head :unauthorized
  end
end
