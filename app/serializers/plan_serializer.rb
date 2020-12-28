class PlanSerializer < ActiveModel::Serializer
  attribute :id
  attribute :name
  attribute :kind
  attribute :cloud
  attribute :location
  attribute :region
  attribute :version
  attribute :price do
    object.price.to_f
  end
  attribute :nodes do
    object.details.fetch('nodes', 1)
  end
  attribute :vcpus do
    object.details.fetch('vcpu', 1)
  end
  attribute :memory do
    object.details.fetch('memory', 1e+9)
  end
  attribute :disk do
    object.details.fetch('disk', 30)
  end
end
