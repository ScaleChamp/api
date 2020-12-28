class ControlPanel::API::V1::SecurityLogsController < ControlPanel::API::V1::ApplicationController
  def index
    security_logs = current_user.security_logs.order(created_at: :desc)
    paginate json: security_logs, per_page: 20
  end
end
