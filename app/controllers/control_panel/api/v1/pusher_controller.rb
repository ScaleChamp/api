class ControlPanel::API::V1::PusherController < ControlPanel::API::V1::ApplicationController
  def create
    case params[:channel_name]
    when /private-instance-(?<instance_id>.*)/
      Instance.find($LAST_MATCH_INFO[:instance_id]).project.users.find(current_user.id)
      response = Pusher.authenticate(params[:channel_name], params[:socket_id])
      render json: response
    when /private-user-(?<user_id>.*)/
      raise ActiveRecord::RecordNotFound if current_user.id != $LAST_MATCH_INFO[:user_id]
      response = Pusher.authenticate(params[:channel_name], params[:socket_id])
      render json: response
    else
      raise ActiveRecord::RecordNotFound
    end
  end
end
