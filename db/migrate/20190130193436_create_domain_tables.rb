class CreateDomainTables < ActiveRecord::Migration[6.0]
  def change
    enable_extension 'uuid-ossp' unless extension_enabled?('uuid-ossp')
    enable_extension 'pgcrypto' unless extension_enabled?('pgcrypto')

    create_table :plans, id: :uuid do |t|
      t.boolean :disabled, null: false, default: false
      t.boolean :deprecated, null: false, default: false
      t.string :kind, null: false
      t.string :name, null: false
      t.string :cloud, null: false
      t.string :region, null: false
      t.string :location # eu/usa
      t.string :category # personal, startup, enterprise
      t.jsonb :details, null: false
      t.decimal :price, null: false, scale: 3, precision: 8
      t.timestamps default: -> { 'current_timestamp' }, null: false
    end

    create_table :users, id: :uuid do |t|
      t.string :otp_secret_key
      t.string :otp_backup_codes, array: true
      t.boolean :otp_required_for_login, default: false, null: false

      t.string :name, null: false

      t.string :email, null: false

      t.string :google_user_id
      t.string :github_user_id

      t.string :password_digest
      t.string :reset_password_token
      t.datetime :reset_password_sent_at

      t.datetime :confirmed_at
      t.string :confirmation_token
      t.datetime :confirmation_sent_at
      t.string :unconfirmed_email

      t.string :auth_method, null: false

      t.timestamps default: -> { 'current_timestamp' }, null: false
    end

    add_index :users, :email, unique: true
    add_index :users, :google_user_id, unique: true
    add_index :users, :github_user_id, unique: true
    add_index :users, :gitlab_user_id, unique: true

    create_table :memberships, id: :uuid do |t|
      t.string :email, null: false
      t.datetime :confirmed_at
      t.string :confirmation_token
      t.datetime :confirmation_sent_at

      t.integer :role, null: false, default: 0
      t.timestamps default: -> { 'current_timestamp' }

      t.belongs_to :project, type: :uuid, null: false, index: true
      t.belongs_to :user, type: :uuid, null: true, index: true
    end

    create_table :instances, id: :uuid do |t|
      t.string :name, null: false

      t.integer :state, null: false, default: 0

      t.string :kind, null: false

      t.boolean :enabled, null: false, default: true

      t.string :eviction_policy, null: false, default: 'noeviction'

      t.string :license_key

      t.inet :whitelist, array: true, default: -> { 'ARRAY []::inet[]' }, null: false

      t.string :secret, null: false
      t.string :username, null: false, default: 'ssn'
      t.string :database, null: false, default: 'defaultdb'
      t.string :password, null: false

      t.jsonb :connection_info, default: -> { "'{}'::jsonb" }
      t.jsonb :metadata, default: -> { "'{}'::jsonb" }
      # t.jsonb :tags, null: false, default: -> { "'[]'::jsonb" }
      t.timestamps default: -> { 'current_timestamp' }

      # # validate that virtual network has same cloud and region as plan
      # # if not exists use default for this cloud from cloud_profile or system based or nothing
      # t.belongs_to :cloud_profile, type: :uuid, index: true # validate that cloud profile
      t.belongs_to :virtual_network, type: :uuid, index: true
      t.belongs_to :project, null: false, type: :uuid, index: true
      t.belongs_to :plan, null: false, type: :uuid, index: true # validate that cloud account available for this plan if cloud_profile not exists usage set usage not chargable
    end

    create_table :nodes, id: :uuid do |t|
      t.integer :state, null: false, default: 0

      t.string :cloud, null: false
      t.string :region, null: false

      t.inet :whitelist, array: true, default: -> { 'ARRAY []::inet[]' }, null: false
      t.jsonb :metadata, default: -> { "'{}'::jsonb" }
      t.timestamps default: -> { 'current_timestamp' }

      t.belongs_to :instance, null: false, type: :uuid, index: true
    end

    create_table :events, id: :uuid do |t|
      t.jsonb :data, null: false, default: -> { "'{}'::jsonb" }
      t.jsonb :metadata, null: false, default: -> { "'{}'::jsonb" }
      t.references :eventable, polymorphic: true, type: :uuid, index: true
      t.timestamps default: -> { 'current_timestamp' }, null: false
    end

    create_table :virtual_networks, id: :uuid do |t|
      t.integer :state, null: false, default: 0
      t.cidr :network, null: false
      t.string :cloud, null: false
      t.string :region, null: false
      t.jsonb :metadata
      t.timestamps default: -> { 'current_timestamp' }
      t.belongs_to :cloud_profile, type: :uuid, null: false, index: true
      t.belongs_to :project, type: :uuid, null: false, index: true
    end

    create_table :peers, id: :uuid do |t|
      t.integer :state, null: false, default: 0
      t.timestamps default: -> { 'current_timestamp' }

      t.jsonb :metadata
      t.belongs_to :virtual_network, type: :uuid, null: false, index: true
    end

    create_table :projects, id: :uuid do |t|
      t.string :description, null: false
      t.integer :services_count_limit, default: 2, null: false
      t.boolean :default, null: false, default: false
      t.string :name, null: false
      t.decimal :credit, null: false, default: 0, scale: 3, precision: 8
      t.decimal :usage, null: false, default: 0, scale: 3, precision: 8
      t.timestamp :billed_at
      t.timestamps default: -> { 'current_timestamp' }
      t.string :currency, null: true, default: 'usd'
    end

    create_table :usages, id: :uuid do |t|
      t.timestamp :started_at, null: false
      t.timestamp :ended_at

      t.belongs_to :project, null: false, type: :uuid, index: true
      t.belongs_to :instance, null: false, type: :uuid, index: true
      t.belongs_to :plan, null: false, type: :uuid, index: true
    end

    create_table :invoices, id: :uuid do |t|
      t.decimal :total, null: false, scale: 3, precision: 8
      t.decimal :credit_applied, null: false, scale: 3, precision: 8
      t.integer :state, null: false, default: 0
      t.jsonb :items, null: false
      t.timestamps default: -> { 'current_timestamp' }

      t.belongs_to :project, null: false, type: :uuid, index: true
    end

    create_table :logs, id: :uuid do |t|
      t.text :data, null: false, default: ''
      t.datetime :created_at, null: false, default: -> { 'current_timestamp' }

      t.belongs_to :node, null: false, type: :uuid, index: true
      t.belongs_to :instance, null: false, type: :uuid, index: true
    end

    create_table :access_keys, id: :uuid do |t|
      t.string :token, null: false, default: -> { 'md5(random()::text)' }
      t.integer :permission
      # t.string :tags, array: true, null: false, default: -> { 'ARRAY []::VARCHAR[]' }
      t.timestamps default: -> { 'current_timestamp' }
      t.string :name, null: false
      t.belongs_to :project, type: :uuid, null: false, index: true
      t.belongs_to :user, type: :uuid, null: false, index: true
    end

    create_table :tasks, id: :uuid do |t|
      t.string :action, null: false
      t.string :kind, null: false
      t.integer :state, null: false, default: 0
      t.jsonb :metadata, null: false, default: -> { "'{}'::jsonb" }
      t.jsonb :data, null: false, default: -> { "'{}'::jsonb" }
      t.timestamps null: false, default: -> { 'current_timestamp' }

      t.belongs_to :instance, type: :uuid, index: true
    end

    create_table :prometheus, id: :uuid do |t|
      t.string :targets, array: true, null: false
      t.jsonb :labels, null: false

      t.timestamps null: false, default: -> { 'current_timestamp' }
      t.uuid :node_id, null: false
    end

    create_table :cloud_profiles, id: :uuid do |t|
      t.string :cloud
      t.jsonb :metadata
      t.timestamps default: -> { 'current_timestamp' }
      t.belongs_to :project, type: :uuid, index: true
    end

    create_table :security_logs, id: :uuid do |t|
      t.string :action_type, null: false
      t.inet :remote_ip, null: false
      t.timestamps default: -> { 'current_timestamp' }
      t.belongs_to :user, type: :uuid, null: false # index
      t.jsonb :data, null: true
    end

    create_table :audit_logs, id: :uuid do |t|
      t.string :action_type, null: false
      t.inet :remote_ip, null: false
      t.timestamps default: -> { 'current_timestamp' }
      t.belongs_to :user, type: :uuid, null: true
      t.belongs_to :project, type: :uuid, null: false
      t.belongs_to :instance, type: :uuid, null: true, index: true
      t.jsonb :data, :jsonb, null: true
    end

    create_table :rates do |t|
      t.string :currency, null: false
      t.decimal :rate, precision: 8, scale: 6, null: false
      t.timestamps
    end

    create_table :checkouts, id: :uuid do |t|
      t.string :paddle_id, null: false, index: true
      t.decimal :amount, null: false
      t.belongs_to :project, type: :uuid, null: false, index: true
      t.belongs_to :user, type: :uuid, null: false, index: true
      t.timestamps
    end
  end
end
