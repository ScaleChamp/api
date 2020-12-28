class AddProjectSecretsTable < ActiveRecord::Migration[6.0]
  def change
    create_table :access_key_pairs, id: :uuid do |t|
      t.string :access_key_id, null: false
      t.string :secret_access_key, null: false
      t.timestamps default: -> { 'current_timestamp' }
      t.belongs_to :instance, type: :uuid, index: true, null: false
    end

    create_table :encryption_keys, id: :uuid do |t|
      t.text :private_key, null: false
      t.text :public_key, null: false
      t.timestamps default: -> { 'current_timestamp' }
      t.belongs_to :instance, type: :uuid, index: true, null: false
    end
  end
end
