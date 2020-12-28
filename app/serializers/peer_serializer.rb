class PeerSerializer < ActiveModel::Serializer
  attribute :id
  attribute :state
  attribute :aws_peer_owner_id
  attribute :aws_peer_region
  attribute :aws_peer_vpc_id
  attribute :virtual_network_id
end
