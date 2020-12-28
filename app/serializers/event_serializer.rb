class EventSerializer < ActiveModel::Serializer
  attribute :id
  attribute :data
  attribute :metadata
  attribute :created_at
end
