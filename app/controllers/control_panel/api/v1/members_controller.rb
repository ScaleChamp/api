class ControlPanel::API::V1::MembersController < ControlPanel::API::V1::ApplicationController
  before_action :set_pundit_user
  before_action :set_member, only: [:update, :destroy]

  delegate :project, to: :pundit_user

  after_action :verify_authorized

  def index
    authorize Membership
    members = project.memberships
    paginate json: members, per_page: 30
  end

  def create
    authorize Membership
    membership = Membership::Invite.(current_user, project, permitted_attributes(Membership))
    render json: membership
  end

  def update
    authorize @member
    @member.update!(permitted_attributes(@member))
    render json: @member
  end

  def destroy
    authorize @member
    @member.destroy
    render json: @member
  end

  private

  def set_member
    @member = project.memberships.find(params[:id])
  end

  def set_pundit_user
    @pundit_user = current_user.memberships.find_by_project_id!(params[:project_id])
  end
end
