class Usage < ApplicationRecord
  default_scope { order(started_at: :asc) }

  validates_presence_of :instance, :project, :started_at, :plan

  belongs_to :project

  belongs_to :instance

  belongs_to :plan
end
