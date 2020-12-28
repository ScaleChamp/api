class VirtualNetwork < ApplicationRecord
  belongs_to :project

  belongs_to :vpc

  has_many :peers

  has_many :instances

  validates :vpc, uniqueness: { scope: :project }

  validate :network_range

  delegate :cloud, :region, to: :vpc

  private

  def network_range
    errors.add(:base, 'invalid network range') if network.prefix != 24 || !network.ipv4? || !network.private?
  end
end
