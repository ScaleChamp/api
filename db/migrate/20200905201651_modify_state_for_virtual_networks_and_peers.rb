class ModifyStateForVirtualNetworksAndPeers < ActiveRecord::Migration[6.0]
  def change
    remove_column :virtual_networks, :state
    remove_column :peers, :state

    add_column :virtual_networks, :state, :string
    add_column :peers, :state, :string
  end
end
