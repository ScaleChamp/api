class ProjectSerializer < ActiveModel::Serializer
  attribute :id
  attribute :created_at
  attribute :name
  attribute :currency
  attribute :services_count_limit
  attribute :description do
    object.description
  end
  attribute :credit, if: :show_credit_and_usage? do
    object.credit.to_f + object.usage.to_f
  end
  attribute :usage, if: :show_credit_and_usage? do
    object.usage.to_f
  end
  attribute :role do
    object.memberships.find_by(user: current_user).try(:role)
  end
  attribute :avatar_url do
    "https://avatars.dicebear.com/v2/initials/#{object.id}.svg"
  end

  def show_credit_and_usage?
    role = object.memberships.find_by(user: current_user).try(:role)
    role == 'accountant' || role == 'owner' || role == 'administrator'
  end

  has_one :certificate_authority
end
