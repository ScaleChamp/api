class AccessKey < ApplicationRecord
  enum permission: {
      ro: 0,
      rw: 1
  }

  has_secure_token :token

  belongs_to :project

  belongs_to :user, optional: true
end
