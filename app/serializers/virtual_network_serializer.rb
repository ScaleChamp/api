class VirtualNetworkSerializer < ActiveModel::Serializer
  attribute :id

  attribute :network do
    "#{object.network.to_s}/#{object.network.prefix}"
  end

  attribute :state

  attribute :cloud

  attribute :region

  attribute :project_id
end
