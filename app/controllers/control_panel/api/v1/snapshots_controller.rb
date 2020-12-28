class ControlPanel::API::V1::SnapshotsController < ControlPanel::API::V1::ApplicationController
  before_action :set_pundit_user
  before_action :set_instance

  delegate :project, to: :pundit_user

  def index
    if [Instance::POSTGRESQL, Instance::MYSQL].include?(@instance.kind)
      response = $s3.list_objects(bucket: BUCKET_NAME, prefix: "#{@instance.id}/basebackups_005")
      snapshots = response.contents.select { |c| c.key.include? 'json' }.map(&method(:snapshot))
    else
      snapshots = $s3.list_objects(bucket: BUCKET_NAME, prefix: "#{@instance.id}").contents.map(&method(:snapshot))
    end
    render json: snapshots.reverse
  end

  private

  def snapshot(x)
    {
        size: x.size,
        last_modified: x.last_modified
    }
  end

  def set_instance
    @instance = project.instances.find(params[:instance_id])
  end

  def set_pundit_user
    @pundit_user = current_user.memberships.find_by_project_id!(params[:project_id])
  end
end
