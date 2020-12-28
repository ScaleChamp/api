class MembershipSerializer < ActiveModel::Serializer
  attribute :id
  attribute :role
  attribute :created_at
  attribute :updated_at
  attribute :email
  attribute :current_user do
    object.user_id == current_user.id
  end
  attribute :state do
    object.confirmed_at ? Membership::JOINED : Membership::PENDING
  end

  has_one :user
end
