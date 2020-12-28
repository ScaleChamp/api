class ControlPanel::API::V1::TicketsController < ControlPanel::API::V1::ApplicationController
  before_action :set_project

  def create
    ticket_id = SecureRandom.hex
    $telegram_bot.api.send_message(
        chat_id: Rails.application.credentials.fetch(:telegram_bot_tickets_chat_id, 423520819),
        text: "Ticket: #{ticket_id}
Environment: #{Rails.env}
User: #{current_user.id}
Name: #{current_user.name}
Email: #{current_user.email}
Project: #{@project.id}
Title: #{ticket_params[:title]}
Topic: #{ticket_params[:topic] || 'Other'}
Severity: #{ticket_params[:severity] || 'Low'}
Description: #{ticket_params[:description] || 'Not Provided'}"
    )
    head :ok
  end

  private

  def ticket_params
    params.permit(:title, :description, :severity, :topic)
  end

  def set_project
    @project = current_user.projects.find(params[:project_id])
  end
end
