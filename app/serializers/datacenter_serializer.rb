class DatacenterSerializer < ActiveModel::Serializer
  attribute :id
  attribute :cloud
  attribute :region
end
