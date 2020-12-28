class CreateMetrics < ActiveRecord::Migration[6.0]
  def up
    enable_extension 'pg_prometheus' unless extension_enabled?('pg_prometheus')

    execute "SELECT create_prometheus_table('metrics', timescaledb=true);" unless extension_enabled?('pg_prometheus')
  end
end
