class ControlPanel::API::V1::BillingController < ControlPanel::API::V1::ApplicationController
  before_action :set_pundit_user

  delegate :project, to: :pundit_user

  def index
    authorize Event
    events = project.events.order(created_at: :desc)
    paginate json: events, per_page: 20
  end

  private

  def set_pundit_user
    @pundit_user = current_user.memberships.find_by_project_id!(params[:project_id])
  end
end
