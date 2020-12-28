class ControlPanel::ApplicationController < ActionController::Base
  include FormAuthenticityToken

  protect_from_forgery with: :exception

  before_action :no_cache
  before_action :authenticate_user
  before_action :authenticate_user!, only: :index, unless: :current_user
  before_action :redirect_to_root_path, only: [:login, :register], if: -> { current_user }

  def index
    render template: "control_panel/application/index"
  end

  def login
    index
  end

  def register
    index
  end

  def not_found
    index
  end

  def tab_by_role
    case Membership.find_by(project_id: params[:project_id], user_id: current_user.id).role
    when 'member', 'administrator', 'owner'
      redirect_to "/projects/#{params[:project_id]}/services"
    else
      redirect_to "/projects/#{params[:project_id]}/billing"
    end
  end

  private

  attr_reader :current_user

  def auth_hash
    request.env['omniauth.auth']
  end

  def omniauth_params
    request.env["omniauth.params"]
  end

  def authenticate_user
    @current_user = User.find_by_id(session[:user_id])
  end

  def redirect_to_root_path
    redirect_to root_path
  end

  def authenticate_user!
    session[:return_to] = request.url
    redirect_to login_path
  end

  def no_cache
    response.headers["Cache-Control"] = "no-cache, no-store"
    response.headers["Pragma"] = "no-cache"
    response.headers["Expires"] = "Mon, 01 Jan 1990 00:00:00 GMT"
  end
end
