class ModifyPeersProps < ActiveRecord::Migration[6.0]
  def change
    change_column :peers, :aws_peer_owner_id, :string, null: false
    change_column :peers, :aws_peer_region, :string, null: false
    change_column :peers, :aws_peer_vpc_id, :string, null: false
  end
end
