class LogSerializer < ActiveModel::Serializer
  attribute :id
  attribute :created_at
  attribute :node_id
  attribute :instance_id
  attribute :data
end
