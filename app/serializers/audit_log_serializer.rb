class AuditLogSerializer < ActiveModel::Serializer
  attribute :id
  attribute :created_at
  attribute :user_id
  attribute :project_id
  attribute :action_type
  attribute :data
  attribute :remote_ip do
    object.remote_ip.to_s
  end

  belongs_to :user
end
