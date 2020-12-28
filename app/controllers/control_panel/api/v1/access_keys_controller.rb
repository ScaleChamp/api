class ControlPanel::API::V1::AccessKeysController < ControlPanel::API::V1::ApplicationController
  before_action :set_pundit_user
  before_action :set_access_key, only: [:update, :destroy]

  delegate :project, to: :pundit_user

  after_action :verify_authorized

  def index
    authorize AccessKey
    access_keys = project.access_keys
    render json: access_keys
  end

  def update
    authorize @access_key
    @access_key.update!(permitted_attributes(@access_key))
    render json: @access_key
  end

  def create
    authorize AccessKey
    access_key = project.access_keys.create!(**permitted_attributes(AccessKey), user: current_user)
    render json: access_key
  end

  def destroy
    authorize @access_key
    @access_key.destroy
    render json: @access_key
  end

  private

  def set_pundit_user
    @pundit_user = current_user.memberships.find_by_project_id!(params[:project_id])
  end

  def set_access_key
    @access_key = project.access_keys.find(params[:id])
  end
end
