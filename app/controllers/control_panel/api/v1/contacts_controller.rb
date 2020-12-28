class ControlPanel::API::V1::ContactsController < ControlPanel::API::V1::ApplicationController
  skip_forgery_protection

  skip_before_action :authenticate_user!

  before_action :verify_recaptcha!

  def create
    $telegram_bot.api.send_message(
        chat_id: Rails.application.credentials.fetch(:telegram_bot_contacts_chat_id, 423520819),
        text: "Name: #{contact_params[:name] || 'n/a'}
Description: #{contact_params[:description] || 'n/a'}
Subject: #{contact_params[:subject] || 'n/a'}
Email: #{contact_params[:email] || 'n/a'}
Reason: #{contact_params[:reason] || 'n/a'}"
    )
    head :ok
  end

  private

  def contact_params
    params.permit(:name, :description, :subject, :email, :reason)
  end
end
