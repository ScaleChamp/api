class ControlPanel::API::V1::PlansController < ControlPanel::API::V1::ApplicationController
  def index
    plans = Plan.enabled.order("kind ASC, cloud ASC, location ASC, region ASC, details ->> 'nodes' ASC, name ASC")
    render json: plans
  end
end
