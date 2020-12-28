class ControlPanel::API::V1::PaddleController < ControlPanel::API::V1::ApplicationController
  before_action :set_project, only: :create

  skip_forgery_protection only: :edit
  skip_before_action :authenticate_user!, only: :edit

  def create
    paylink = Checkout::Create.(current_user, params, @project)
    response.set_header(ActionDispatch::Response::LOCATION, paylink)
    head :created
  end

  def update
    Checkout::Capture.(current_user, 'checkout', params[:id])
    head :ok
  end

  def edit
    Checkout::Capture.(nil, 'order', params[:p_order_id])
    head :ok
  end

  private

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end
end
