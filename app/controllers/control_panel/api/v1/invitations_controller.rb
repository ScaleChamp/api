class ControlPanel::API::V1::InvitationsController < ControlPanel::API::V1::ApplicationController
  def show
    membership = Membership.find_by_confirmation_token!(params[:id])
    raise CustomError.new('already-joined') if membership.confirmed_at
    render json: membership.project
  end

  def update
    membership = Membership.find_by_confirmation_token!(params[:id])
    raise CustomError.new('already-joined') if membership.confirmed_at
    membership.user = current_user
    membership.confirmed_at = Time.now
    membership.save!
    render json: membership.project
  end
end
