class ModifyState < ActiveRecord::Migration[6.0]
  def change
    change_column :virtual_networks, :state, :string, default: 'pending', null: false
    change_column :peers, :state, :string, default: 'pending', null: false
  end
end
