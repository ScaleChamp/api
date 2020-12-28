class Instance < ApplicationRecord
  KEYDB_PRO = 'keydb-pro'
  KEYDB = 'keydb'
  REDIS = 'redis'
  POSTGRESQL = 'pg'
  MYSQL = 'mysql'

  PASSWORD_FORMAT = /\A[A-Za-z0-9]+\z/

  enum state: {
      pending: 0,
      running: 1,
      terminated: 2,
      unhealthy: 3,
      maintenance: 4,
      disabled: 5
  }

  validates :name, presence: true

  validates :eviction_policy, inclusion: {in: ['noeviction', 'allkeys-lru', 'volatile-lru', 'allkeys-random', 'volatile-random', 'volatile-ttl']}

  validates :password, presence: true, length: {in: 24..32}, format: {with: PASSWORD_FORMAT}

  validates :secret, presence: true, length: { is: 32 }, format: {with: PASSWORD_FORMAT}

  validates :kind, presence: true

  validates :license_key, presence: true, if: -> { kind == KEYDB_PRO }

  validate :instance_has_same_kind_as_plan, if: -> { plan_id_changed? }

  validate :whitelist_no_nil

  validates_absence_of :virtual_network, if: -> { !cloud_profile.blank? }

  validates_absence_of :cloud_profile, if: -> { !virtual_network.blank? }

  validate :virtual_network_match_plan, if: -> { !virtual_network.blank? }

  validate :cloud_profile_match_plan, if: -> { !cloud_profile.blank? }

  # validate that plan cloud same as virtual network cloud and region is the same or absent

  belongs_to :project

  belongs_to :plan

  belongs_to :virtual_network, optional: true

  belongs_to :cloud_profile, optional: true

  has_one :access_key_pair

  has_one :encryption_key

  has_many :logs

  has_many :nodes, dependent: :destroy

  has_many :usages, dependent: :destroy

  has_many :tasks, dependent: :destroy

  has_many :audit_logs

  private

  # def instance_has_same_kind_as_plan
  #   errors.add(:base, 'plan kind mismatch') if Plan.find(plan_id_was).kind != plan.kind
  # end

  def virtual_network_match_plan
    errors.add(:base, 'plan virtual_network mismatch') if virtual_network.cloud != plan.cloud && virtual_network.region.start_with?(cloud_profile.region)
  end

  def cloud_profile_match_plan
    errors.add(:base, 'plan cloud_profile mismatch') if cloud_profile.cloud != plan.cloud && plan.region.start_with?(cloud_profile.region)
  end

  def instance_has_same_kind_as_plan
    errors.add(:base, 'plan kind mismatch') unless kind == plan.kind
  end

  def whitelist_no_nil
    errors.add(:base, 'whitelist has nil') if whitelist.any?(nil)
  end
end
