class AuditLog < ApplicationRecord
  INSTANCE_CREATED = 'instance.created'
  INSTANCE_DESTROY = 'instance.destroyed'
  PROJECT_CREATED = 'project.created'

  belongs_to :project

  belongs_to :user

  belongs_to :instance, optional: true
end
