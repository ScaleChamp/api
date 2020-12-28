require 'httparty'

class ExchangeClient
  BASE_URL = 'https://openexchangerates.org'
  APP_ID = Rails.application.credentials.fetch(:exchange_app_id)
  BASE = 'USD'

  include HTTParty

  headers 'Content-Type' => 'application/json'

  base_uri BASE_URL

  format :json

  class << self
    def latest
      get '/api/latest.json', query: {
          base: BASE,
          app_id: APP_ID
      }
    end
  end
end
