class CreateDatacenters < ActiveRecord::Migration[6.0]
  def change
    remove_column :virtual_networks, :cloud, :string
    remove_column :virtual_networks, :region , :string

    create_table :datacenters, id: :uuid do |t|
      t.string :cloud, null: false
      t.string :region, null: false
      t.string :type, index: true

      t.timestamps default: -> { 'current_timestamp' }, null: false
    end

    add_index :datacenters, [:cloud, :region], unique: true

    add_belongs_to :virtual_networks, :vpc, type: :uuid, null: false, index: true
  end
end
