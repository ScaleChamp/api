class Plan < ApplicationRecord
  validates :name, presence: true

  validates :cloud, presence: true

  validates :region, presence: true

  scope :active, -> { where.not('disabled') }

  scope :enabled, -> { where.not('deprecated') }

  has_many :instances
end
