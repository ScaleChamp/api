class UserSerializer < ActiveModel::Serializer
  attribute :id
  attribute :name
  attribute :email
  attribute :created_at
  attribute :updated_at
  attribute :auth_method
  attribute :otp_required_for_login, key: :tfa
  attribute :avatar_url do
    "https://avatars.dicebear.com/v2/initials/#{object.id}.svg"
  end
end
