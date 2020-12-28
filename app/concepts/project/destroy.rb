class Project::Destroy < ServiceObject
  attr_reader :project, :request

  def initialize(project, request)
    @project = project
    @request = request
  end

  def call

    Project.transaction do
      raise CustomError.new('you-should-destroy-all-services-first') unless project.instances.where.not(state: :terminated).empty?
      telegram_notify(project)
      project.memberships.each(&:destroy)
      project.destroy
    end
  end

  private

  def telegram_notify(project)
    $telegram_bot.api.send_message(
        chat_id: Rails.application.credentials.fetch(:telegram_bot_contacts_chat_id, 423520819),
        text: "Project #{project.id} #{project.name}: #{project.usage}, #{project.credit} deleted"
    )
  rescue
    return
  end
end
