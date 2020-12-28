Rails.application.config.middleware.insert_before 0, Rack::Cors do
  allow do
    origins '*'
    resource '/api/v1/plans', headers: :any, methods: :get
    resource '/api/v1/contacts', headers: :any, methods: :post
  end
end
