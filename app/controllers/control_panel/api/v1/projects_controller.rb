class ControlPanel::API::V1::ProjectsController < ControlPanel::API::V1::ApplicationController
  before_action :set_pundit_user, only: [:update, :destroy, :show]

  delegate :project, to: :pundit_user, prefix: true

  after_action :verify_authorized, only: [:update, :destroy, :show]

  def index
    projects = current_user.projects.order(created_at: :desc)
    paginate json: projects, per_page: 5
  end

  def create
    project = Project::Create.(current_user, request, permitted_attributes(Project))
    render json: project
  end

  def show
    authorize pundit_user_project
    render json: pundit_user_project
  end

  def update
    authorize pundit_user_project
    pundit_user_project.update!(permitted_attributes(pundit_user_project))
    render json: pundit_user_project
  end

  def destroy
    authorize pundit_user_project
    Project::Destroy.(pundit_user_project, request)
    render json: pundit_user_project
  end

  private

  def set_pundit_user
    @pundit_user = current_user.memberships.find_by_project_id!(params[:id])
  end
end
