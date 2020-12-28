require 'telegram/bot'

TELEGRAM_BOT_TOKEN = Rails.application.credentials.fetch(:telegram_bot_token)

$telegram_bot = Telegram::Bot::Client.new(TELEGRAM_BOT_TOKEN)
