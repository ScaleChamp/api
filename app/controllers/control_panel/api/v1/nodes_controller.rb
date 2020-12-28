class ControlPanel::API::V1::NodesController < ControlPanel::API::V1::ApplicationController
  before_action :set_pundit_user
  before_action :set_instance

  delegate :project, to: :pundit_user

  def index
    nodes = @instance.nodes
    render json: nodes
  end

  private

  def set_instance
    @instance = project.instances.find(params[:instance_id])
  end

  def set_pundit_user
    @pundit_user = current_user.memberships.find_by_project_id!(params[:project_id])
  end
end
