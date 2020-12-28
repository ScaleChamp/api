class TaskSerializer < ActiveModel::Serializer
  attribute :id
  attribute :state
  attribute :created_at
  attribute :updated_at, if: -> { object.updated_at != object.created_at }
  attribute :action do
    object.action.split('-').first
  end
end
