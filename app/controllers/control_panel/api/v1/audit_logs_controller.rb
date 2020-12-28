class ControlPanel::API::V1::AuditLogsController < ControlPanel::API::V1::ApplicationController
  before_action :set_pundit_user

  delegate :project, to: :pundit_user

  def index
    audit_logs = project.audit_logs.order(created_at: :desc).includes(:user)
    paginate json: audit_logs, per_page: 30
  end

  private

  def set_pundit_user
    @pundit_user = current_user.memberships.find_by_project_id!(params[:project_id])
  end
end
