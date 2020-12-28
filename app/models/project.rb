class Project < ApplicationRecord
  USER_PAYMENT = 'user-payment'
  JUST_CREATED = 'just-created'
  PROMOTIONAL_CREDIT = 'promotional-credit'

  enum currency: {
      ars: 'ars',
      aud: 'aud',
      gbp: 'gbp',
      cad: 'cad',
      czk: 'czk',
      dkk: 'dkk',
      eur: 'eur',
      hkd: 'hkd',
      huf: 'huf',
      inr: 'inr',
      jpy: 'jpy',
      mxn: 'mxn',
      twd: 'twd',
      nzd: 'nzd',
      nok: 'nok',
      pln: 'pln',
      rub: 'rub',
      sgd: 'sgd',
      krw: 'krw',
      sek: 'sek',
      chf: 'chf',
      thb: 'thb',
      usd: 'usd'
  }

  validates :name, presence: true

  validates :description, presence: true

  validates :currency, inclusion: {in: currencies.values}

  has_many :memberships

  has_many :users, through: :memberships

  has_many :events, as: :eventable

  has_many :usages

  has_many :invoices

  has_many :instances, before_add: :validate_project_limit

  has_many :access_keys

  has_many :checkouts

  has_many :cloud_profiles

  has_many :virtual_networks

  has_many :audit_logs

  has_one :certificate_authority

  private

  def validate_project_limit(instance)
    raise SoftLimit if instances.not_terminated.size >= instance.project.services_count_limit
  end
end
