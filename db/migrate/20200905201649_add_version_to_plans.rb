class AddVersionToPlans < ActiveRecord::Migration[6.0]
  def change
    add_column :plans, :version, :string, default: '', null: false
  end
end
