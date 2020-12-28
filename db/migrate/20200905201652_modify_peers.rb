class ModifyPeers < ActiveRecord::Migration[6.0]
  def change
    add_column :peers, :aws_peer_owner_id, :string
    add_column :peers, :aws_peer_region, :string
    add_column :peers, :aws_peer_vpc_id, :string
  end
end
