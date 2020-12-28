class ControlPanel::API::V1::CloudProfilesController < ControlPanel::API::V1::ApplicationController
  before_action :set_pundit_user
  before_action :set_cloud_profile, except: [:index, :create]

  delegate :project, to: :pundit_user

  after_action :verify_authorized

  def index
    authorize CloudProfile
    render json: project.cloud_profiles
  end

  def show
    authorize @cloud_profile
    render json: @cloud_profile
  end

  def create
    authorize CloudProfile
    cloud_profile = project.cloud_profiles.create!(permitted_attributes(CloudProfile))
    render json: cloud_profile
  end

  def destroy
    authorize @cloud_profile
    @cloud_profile.destroy
    render json: @cloud_profile
  end

  private

  def set_pundit_user
    @pundit_user = current_user.memberships.find_by_project_id!(params[:project_id])
  end

  def set_cloud_profile
    @cloud_profile = project.cloud_profiles.find(params[:id])
  end
end
