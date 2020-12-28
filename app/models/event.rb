class Event < ApplicationRecord
  belongs_to :eventable, polymorphic: true
end
