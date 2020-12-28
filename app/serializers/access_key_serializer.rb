class AccessKeySerializer < ActiveModel::Serializer
  attribute :id
  attribute :name
  attribute :token
  attribute :permission
  attribute :project_id
  attribute :created_at
end
