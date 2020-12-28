class RemoveCloudProfileFromVirtualNetwork < ActiveRecord::Migration[6.0]
  def change
    remove_column :virtual_networks, :cloud_profile_id

    add_belongs_to :instances, :cloud_profile, type: :uuid
  end
end
