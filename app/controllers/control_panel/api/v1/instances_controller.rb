class ControlPanel::API::V1::InstancesController < ControlPanel::API::V1::ApplicationController
  before_action :set_pundit_user
  before_action :set_instance, except: [:index, :create]

  delegate :project, to: :pundit_user

  after_action :verify_authorized

  def index
    authorize Instance
    instances = project.instances.not_terminated.order(created_at: :desc).includes(:plan)
    paginate json: instances, per_page: 100
  end

  def show
    authorize @instance
    render json: @instance
  end

  def create
    authorize Instance
    instance = Instance::Create.(current_user, project, permitted_attributes(Instance), request)
    render json: instance
  end

  def update
    authorize @instance
    instance = Instance::Update.(current_user, request, @instance, permitted_attributes(@instance))
    render json: instance
  end

  def destroy
    authorize @instance
    Instance::Destroy.(current_user, @instance, request)
    head :no_content
  end

  private

  def set_instance
    @instance = project.instances.find(params[:id])
  end

  def set_pundit_user
    @pundit_user = current_user.memberships.find_by_project_id!(params[:project_id])
  end
end

