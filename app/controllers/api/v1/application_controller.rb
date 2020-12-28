class API::V1::ApplicationController < ActionController::API
  include ActionController::HttpAuthentication::Token::ControllerMethods

  rescue_from CustomError, with: :show_message
  rescue_from AccessDenied, with: :deny_access

  private

  def show_message(exception)
    render json: {message: exception.message}, status: 400
  end

  def deny_access(exception)
    render json: {message: 'not-enough-permissions'}, status: 401
  end

  def authorize_user
    authenticate_or_request_with_http_token do |token, _options|
      @access_key = AccessKey.find_by_token!(token)
      @project = @access_key.project
    end
  end
end
