class API::V1::PlansController < API::V1::ApplicationController
  def new
    plan = Plan.active.find_by!(plan_params)
    render json: plan
  end

  def index
    plans = Plan.active
    render json: plans
  end

  private

  def plan_params
    params.permit(:kind, :name, :cloud, :region)
  end
end
