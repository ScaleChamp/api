class ControlPanel::API::V1::VirtualNetworksController < ControlPanel::API::V1::ApplicationController
  before_action :set_pundit_user
  before_action :set_virtual_network, except: [:index, :create]

  delegate :project, to: :pundit_user

  after_action :verify_authorized

  def index
    authorize VirtualNetwork
    render json: project.virtual_networks
  end

  def show
    authorize @virtual_network
    render json: @virtual_network
  end

  def create
    authorize VirtualNetwork
    virtual_network = project.virtual_networks.create!(permitted_attributes(VirtualNetwork))
    render json: virtual_network
  end

  def destroy
    authorize @virtual_network
    VirtualNetwork::Destroy.(@virtual_network)
    render json: @virtual_network
  end

  private

  def set_pundit_user
    @pundit_user = current_user.memberships.find_by_project_id!(params[:project_id])
  end

  def set_virtual_network
    @virtual_network = project.virtual_networks.find(params[:id])
  end
end
