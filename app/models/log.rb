class Log < ApplicationRecord
  belongs_to :instance

  belongs_to :node

  class << self
    def in_order
      order(created_at: :asc)
    end

    def recent(n)
      in_order.endmost(n)
    end

    def endmost(n)
      all.only(:order).from(all.reverse_order.limit(n), table_name)
    end
  end
end
