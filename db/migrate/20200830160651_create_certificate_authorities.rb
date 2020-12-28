class CreateCertificateAuthorities < ActiveRecord::Migration[6.0]
  def change
    create_table :certificate_authorities, id: :uuid do |t|
      t.text :key, null: false
      t.text :crt, null: false
      t.timestamps default: -> { 'current_timestamp' }, null: false
      t.belongs_to :project, type: :uuid, index: true, null: false
    end
  end
end
