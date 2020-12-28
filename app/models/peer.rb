class Peer < ApplicationRecord
  validates :aws_peer_owner_id, presence: true, if: -> { cloud == 'aws' }
  validates :aws_peer_region, presence: true, inclusion: { in: %w(eu-north-1) }, if: -> { cloud == 'aws' }
  validates :aws_peer_vpc_id, presence: true, format: { with: /vpc-[a-zA-Z0-9]+/ }, if: -> { cloud == 'aws' }

  delegate :cloud, to: :virtual_network

  belongs_to :virtual_network
end
