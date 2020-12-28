class ControlPanel::InvoicesController < ControlPanel::ApplicationController
  include Pundit

  etag { current_user.try :id }

  skip_before_action :no_cache

  before_action :authenticate_user!
  before_action :set_pundit_user
  before_action :set_invoice, only: :show

  rescue_from ActiveRecord::RecordNotFound, with: :index

  delegate :project, to: :pundit_user

  after_action :verify_authorized

  def show
    authorize @invoice
    if stale?(@invoice)
      respond_to do |format|
        format.pdf { render pdf: 'invoice', dpi: 75 }
        format.json { render json: @invoice }
        format.html { index }
      end
    end
  end

  private

  def set_pundit_user
    @pundit_user = current_user.memberships.find_by_project_id!(params[:project_id])
  end

  def set_invoice
    @invoice = project.invoices.find(params[:id])
  end
end
