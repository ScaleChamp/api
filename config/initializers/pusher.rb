require 'pusher'

Pusher.app_id = Rails.application.credentials.fetch(:pusher_app_id)
Pusher.key = Rails.application.credentials.fetch(:pusher_key)
Pusher.secret = Rails.application.credentials.fetch(:pusher_secret)
Pusher.cluster = Rails.application.credentials.fetch(:pusher_cluster)
Pusher.logger = Rails.logger
Pusher.encrypted = true
