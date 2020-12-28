class ControlPanel::API::V1::PeersController < ControlPanel::API::V1::ApplicationController
  before_action :set_pundit_user
  before_action :set_virtual_network
  before_action :set_peer, except: [:index, :create]

  delegate :project, to: :pundit_user

  after_action :verify_authorized

  def index
    authorize Peer
    peers = @virtual_network.peers
    render json: peers
  end

  def create
    authorize Peer
    peer = @virtual_network.peers.create!(permitted_attributes(Peer))
    render json: peer
  end

  def destroy
    authorize @peer
    @peer.destroy
    render json: @peer
  end

  private

  def set_pundit_user
    @pundit_user = current_user.memberships.find_by_project_id!(params[:project_id])
  end

  def set_virtual_network
    @virtual_network = project.virtual_networks.find(params[:virtual_network_id])
  end

  def set_peer
    @peer = @virtual_network.peers.find(params[:id])
  end
end
