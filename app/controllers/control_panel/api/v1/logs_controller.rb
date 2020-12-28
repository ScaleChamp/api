class ControlPanel::API::V1::LogsController < ControlPanel::API::V1::ApplicationController
  before_action :set_pundit_user
  before_action :set_instance

  delegate :project, to: :pundit_user

  after_action :verify_authorized

  LINES_LIMIT = 1000

  def index
    authorize Log
    logs = @instance.logs.recent(LINES_LIMIT)
    render json: logs
  end

  private

  def set_instance
    @instance = project.instances.find(params[:instance_id])
  end

  def set_pundit_user
    @pundit_user = current_user.memberships.find_by_project_id!(params[:project_id])
  end
end
