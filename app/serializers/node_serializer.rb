class NodeSerializer < ActiveModel::Serializer
  attribute :id
  attribute :cloud
  attribute :region
  attribute :whitelist
  attribute :created_at
  attribute :state
  attribute :metadata
  attribute :role do
    role = object.metadata['role']
    if role.blank?
      'not_available'
    else
      role
    end
  end
end
