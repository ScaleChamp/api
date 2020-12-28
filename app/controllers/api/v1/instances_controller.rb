class API::V1::InstancesController < API::V1::ApplicationController
  before_action :authorize_user
  before_action :set_instance, except: [:create]
  before_action :read_write_only, only: [:create, :update, :destroy]

  def show
    render json: @instance
  end

  def create
    instance = Instance::Create.(nil, @project, instance_params, request)
    render json: instance
  end

  def update
    instance = Instance::Update.(nil, request, @instance, instance_params)
    render json: instance
  end

  def destroy
    Instance::Destroy.(nil, @instance, request)
    head :no_content
  end

  private

  def read_write_only
    raise AccessDenied if @access_key.ro?
  end

  def set_instance
    @instance = @project.instances.find(params[:id])
  end

  def instance_params
    params.permit(:project_id, :id, :name, :password, :enabled, :license_key, :eviction_policy, :plan_id, whitelist: [])
  end
end
