class Node < ApplicationRecord
  enum state: {
      pending: 0,
      running: 1,
      failure: 2,
      orphaned: 3
  }

  has_many :logs

  belongs_to :instance
end
