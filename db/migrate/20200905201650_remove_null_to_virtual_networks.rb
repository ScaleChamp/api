class RemoveNullToVirtualNetworks < ActiveRecord::Migration[6.0]
  def change
    change_column_null :virtual_networks, :cloud_profile_id, true
  end
end
