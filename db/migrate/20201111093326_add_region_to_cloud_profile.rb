class AddRegionToCloudProfile < ActiveRecord::Migration[6.0]
  def change
    add_column :cloud_profiles, :region, :string, null: false, default: ''
  end
end
