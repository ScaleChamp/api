class ControlPanel::API::V1::DatacentersController < ControlPanel::API::V1::ApplicationController
  def index
    datacenters = Datacenter.all
    render json: datacenters
  end
end
