class ControlPanel::API::V1::VpcsController < ControlPanel::API::V1::ApplicationController
  def index
    vpcs = VPC.all
    render json: vpcs
  end
end
