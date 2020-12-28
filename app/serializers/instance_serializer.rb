class InstanceSerializer < ActiveModel::Serializer
  DOMAIN = 'scalechamp.net'

  attribute :id
  attribute :name
  attribute :kind
  attribute :password
  attribute :created_at
  attribute :state
  attribute :enabled
  attribute :project_id
  attribute :virtual_network_id
  attribute :plan_id
  attribute :license_key, if: :keydb_pro?
  attribute :eviction_policy, if: :redis_protocol?
  attribute :port do
    case object.kind
    when Instance::REDIS, Instance::KEYDB, Instance::KEYDB_PRO
      6379
    when Instance::POSTGRESQL
      5432
    when Instance::MYSQL
      3306
    else
      raise CustomError
    end
  end

  attribute :master_url do
    case object.kind
    when Instance::REDIS, Instance::KEYDB, Instance::KEYDB_PRO
      "redis://ssnuser:#{object.password}@master-#{object.id}.#{DOMAIN}:6379"
    when Instance::POSTGRESQL
      "postgres://ssnuser:#{object.password}@master-#{object.id}.#{DOMAIN}:5432/ssndb"
    when Instance::MYSQL
      "mysql://ssnuser:#{object.password}@master-#{object.id}.#{DOMAIN}:3306/ssndb"
    else
      raise CustomError
    end
  end

  attribute :slave_url, if: :two_nodes? do
    case object.kind
    when Instance::REDIS, Instance::KEYDB, Instance::KEYDB_PRO
      "redis://ssnuser:#{object.password}@slave-#{object.id}.#{DOMAIN}:6379"
    when Instance::POSTGRESQL
      "postgres://ssnuser:#{object.password}@slave-#{object.id}.#{DOMAIN}:5432/ssndb"
    when Instance::MYSQL
      "mysql://ssnuser:#{object.password}@slave-#{object.id}.#{DOMAIN}:3306/ssndb"
    else
      raise CustomError
    end
  end

  def two_nodes?
    object.plan.details['nodes'] == 2
  end

  attribute :whitelist do
    object.whitelist.nil? ? [] : object.whitelist.map { |ip| "#{ip.to_s}/#{ip.prefix}" }
  end

  attribute :connection_info do
    one_node = object.plan.details.fetch('nodes') == 1
    two_nodes = object.plan.details.fetch('nodes') == 2
    connection_info = {}
    connection_info[:master_host] = "master-#{object.id}.#{DOMAIN}" if (one_node || two_nodes)
    connection_info[:replica_host] = "slave-#{object.id}.#{DOMAIN}" if two_nodes
    connection_info
  end

  belongs_to :plan

  def redis_protocol?
    object.kind == Instance::REDIS || object.kind == Instance::KEYDB || object.kind == Instance::KEYDB_PRO
  end

  def keydb_pro?
    object.kind == Instance::KEYDB_PRO
  end
end
