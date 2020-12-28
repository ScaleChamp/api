class Metric < ApplicationRecord
  def self.node_id_data_by_instance_id(id)
    select('node_id, json_object_agg(name, time_value_arr) as data').from(
        select("\"labels\" ->> 'node_id' as node_id, json_agg(json_build_array(time, value)) as time_value_arr, name")
            .where("\"labels\" ->> 'instance_id' = ? and time > current_timestamp - interval '6 hours'", id.to_s)
            .group("name, \"labels\" ->> 'node_id'")
    ).group("node_id")
  end
end
