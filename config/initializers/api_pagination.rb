require 'api-pagination'
require 'will_paginate/array'

ApiPagination.configure do |config|
  config.total_header = 'X-Total'
  config.per_page_header = 'X-Per-Page'
  config.page_header = 'X-Page'
  config.response_formats = [:json]
  config.page_param = :page
  config.include_total = true
end
