class Checkout < ApplicationRecord
  belongs_to :project
  belongs_to :user

  validates :paddle_id, uniqueness: true, presence: true

  def to_json
    CheckoutSerializer.new(self).to_json
  end
end
