class Tax < ApplicationRecord
  def self.find_by_ip(ip)
    record = $maxminddb.get(ip)

    if record.nil?
      raise ActiveRecord::RecordNotFound
    elsif record['country']['iso_code'] == 'US'
      Tax.find_by!(
          country: record['country']['iso_code'],
          state: record['subdivisions']['iso_code']
      )
    else
      Tax.find_by_country!(record['country']['iso_code'])
    end
  rescue ActiveRecord::RecordNotFound
    OpenStruct.new(rate: 0)
  end
end
