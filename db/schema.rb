# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_02_11_104434) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_prometheus"
  enable_extension "pgcrypto"
  enable_extension "plpgsql"
  enable_extension "timescaledb"
  enable_extension "uuid-ossp"

  create_table "access_keys", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "token", default: -> { "md5((random())::text)" }, null: false
    t.integer "permission"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "name", null: false
    t.uuid "project_id", null: false
    t.uuid "user_id", null: false
    t.index ["project_id"], name: "index_access_keys_on_project_id"
    t.index ["user_id"], name: "index_access_keys_on_user_id"
  end

  create_table "audit_logs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "action_type", null: false
    t.inet "remote_ip", null: false
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "user_id"
    t.uuid "project_id", null: false
    t.uuid "instance_id"
    t.jsonb "data"
    t.jsonb "jsonb"
    t.index ["instance_id"], name: "index_audit_logs_on_instance_id"
    t.index ["project_id"], name: "index_audit_logs_on_project_id"
    t.index ["user_id"], name: "index_audit_logs_on_user_id"
  end

  create_table "checkouts", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "paddle_id", null: false
    t.decimal "amount", null: false
    t.uuid "project_id", null: false
    t.uuid "user_id", null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
    t.index ["paddle_id"], name: "index_checkouts_on_paddle_id"
    t.index ["project_id"], name: "index_checkouts_on_project_id"
    t.index ["user_id"], name: "index_checkouts_on_user_id"
  end

  create_table "cloud_profiles", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "cloud"
    t.jsonb "metadata"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "project_id"
    t.index ["project_id"], name: "index_cloud_profiles_on_project_id"
  end

  create_table "events", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.jsonb "data", default: {}, null: false
    t.jsonb "metadata", default: {}, null: false
    t.string "eventable_type"
    t.uuid "eventable_id"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["eventable_type", "eventable_id"], name: "index_events_on_eventable_type_and_eventable_id"
  end

  create_table "instances", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "name", null: false
    t.integer "state", default: 0, null: false
    t.string "kind", null: false
    t.boolean "enabled", default: true, null: false
    t.string "eviction_policy", default: "noeviction", null: false
    t.string "license_key"
    t.inet "whitelist", null: false, array: true
    t.string "secret", null: false
    t.string "username", default: "ssn", null: false
    t.string "database", default: "defaultdb", null: false
    t.string "password", null: false
    t.jsonb "connection_info", default: {}
    t.jsonb "metadata", default: {}
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "virtual_network_id"
    t.uuid "project_id", null: false
    t.uuid "plan_id", null: false
    t.index ["plan_id"], name: "index_instances_on_plan_id"
    t.index ["project_id"], name: "index_instances_on_project_id"
    t.index ["virtual_network_id"], name: "index_instances_on_virtual_network_id"
  end

  create_table "invoices", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.decimal "total", precision: 8, scale: 3, null: false
    t.decimal "credit_applied", precision: 8, scale: 3, null: false
    t.integer "state", default: 0, null: false
    t.jsonb "items", null: false
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "project_id", null: false
    t.index ["project_id"], name: "index_invoices_on_project_id"
  end

  create_table "logs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.text "data", default: "", null: false
    t.datetime "created_at", default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "node_id", null: false
    t.uuid "instance_id", null: false
    t.index ["instance_id"], name: "index_logs_on_instance_id"
    t.index ["node_id"], name: "index_logs_on_node_id"
  end

  create_table "memberships", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "email", null: false
    t.datetime "confirmed_at"
    t.string "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.integer "role", default: 0, null: false
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "project_id", null: false
    t.uuid "user_id"
    t.index ["project_id"], name: "index_memberships_on_project_id"
    t.index ["user_id"], name: "index_memberships_on_user_id"
  end

# Could not dump table "metrics_copy" because of following StandardError
#   Unknown type 'prom_sample' for column 'sample'

  create_table "metrics_labels", id: :serial, force: :cascade do |t|
    t.text "metric_name", null: false
    t.jsonb "labels"
    t.index ["labels"], name: "metrics_labels_labels_idx", using: :gin
    t.index ["metric_name", "labels"], name: "metrics_labels_metric_name_labels_key", unique: true
    t.index ["metric_name"], name: "metrics_labels_metric_name_idx"
  end

  create_table "metrics_values", id: false, force: :cascade do |t|
    t.datetime "time", null: false
    t.float "value"
    t.integer "labels_id"
    t.index ["labels_id", "time"], name: "metrics_values_labels_id_idx", order: {time: :desc}
    t.index ["time"], name: "metrics_values_time_idx", order: :desc
  end

  create_table "nodes", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "state", default: 0, null: false
    t.string "cloud", null: false
    t.string "region", null: false
    t.inet "whitelist", null: false, array: true
    t.jsonb "metadata", default: {}
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "instance_id", null: false
    t.index ["instance_id"], name: "index_nodes_on_instance_id"
  end

  create_table "peers", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "state", default: 0, null: false
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.jsonb "metadata"
    t.uuid "virtual_network_id", null: false
    t.index ["virtual_network_id"], name: "index_peers_on_virtual_network_id"
  end

  create_table "plans", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.boolean "disabled", default: false, null: false
    t.boolean "deprecated", default: false, null: false
    t.string "kind", null: false
    t.string "name", null: false
    t.string "cloud", null: false
    t.string "region", null: false
    t.string "location"
    t.string "category"
    t.jsonb "details", null: false
    t.decimal "price", precision: 8, scale: 3, null: false
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
  end

  create_table "projects", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "description", null: false
    t.integer "services_count_limit", default: 2, null: false
    t.boolean "default", default: false, null: false
    t.string "name", null: false
    t.decimal "credit", precision: 8, scale: 3, default: "0.0", null: false
    t.decimal "usage", precision: 8, scale: 3, default: "0.0", null: false
    t.datetime "billed_at"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.string "currency", default: "usd"
  end

  create_table "prometheus", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "targets", null: false, array: true
    t.jsonb "labels", null: false
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "node_id", null: false
  end

  create_table "rates", force: :cascade do |t|
    t.string "currency", null: false
    t.decimal "rate", precision: 8, scale: 6, null: false
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "security_logs", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "action_type", null: false
    t.inet "remote_ip", null: false
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "user_id", null: false
    t.jsonb "data"
    t.index ["user_id"], name: "index_security_logs_on_user_id"
  end

  create_table "tasks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "action", null: false
    t.string "kind", null: false
    t.integer "state", default: 0, null: false
    t.jsonb "metadata", default: {}, null: false
    t.jsonb "data", default: {}, null: false
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "instance_id"
    t.index ["instance_id"], name: "index_tasks_on_instance_id"
  end

  create_table "usages", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.datetime "started_at", null: false
    t.datetime "ended_at"
    t.uuid "project_id", null: false
    t.uuid "instance_id", null: false
    t.uuid "plan_id", null: false
    t.index ["instance_id"], name: "index_usages_on_instance_id"
    t.index ["plan_id"], name: "index_usages_on_plan_id"
    t.index ["project_id"], name: "index_usages_on_project_id"
  end

  create_table "users", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.string "otp_secret_key"
    t.string "otp_backup_codes", array: true
    t.boolean "otp_required_for_login", default: false, null: false
    t.string "name", null: false
    t.string "email", null: false
    t.string "google_user_id"
    t.string "github_user_id"
    t.string "gitlab_user_id"
    t.string "bitbucket_user_id"
    t.string "password_digest"
    t.string "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "confirmed_at"
    t.string "confirmation_token"
    t.datetime "confirmation_sent_at"
    t.string "unconfirmed_email"
    t.string "auth_method", null: false
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["github_user_id"], name: "index_users_on_github_user_id", unique: true
    t.index ["gitlab_user_id"], name: "index_users_on_gitlab_user_id", unique: true
    t.index ["google_user_id"], name: "index_users_on_google_user_id", unique: true
  end

  create_table "virtual_networks", id: :uuid, default: -> { "gen_random_uuid()" }, force: :cascade do |t|
    t.integer "state", default: 0, null: false
    t.cidr "network", null: false
    t.string "cloud", null: false
    t.string "region", null: false
    t.jsonb "metadata"
    t.datetime "created_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.datetime "updated_at", precision: 6, default: -> { "CURRENT_TIMESTAMP" }, null: false
    t.uuid "cloud_profile_id", null: false
    t.uuid "project_id", null: false
    t.index ["cloud_profile_id"], name: "index_virtual_networks_on_cloud_profile_id"
    t.index ["project_id"], name: "index_virtual_networks_on_project_id"
  end
end
