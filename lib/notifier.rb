require 'httparty'

module Notifier
  NOTIFIER_URL = Rails.application.credentials.fetch(:notifier_url, 'http://0.0.0.0:9100')

  class Client
    include HTTParty

    headers 'Content-Type' => 'application/json'

    base_uri NOTIFIER_URL

    format :json

    class << self
      def mail(data)
        post "/notifications", {body: data.to_json}
      end
    end
  end
end
