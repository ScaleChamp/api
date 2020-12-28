class User::Create < ServiceObject
  attr_reader :params, :request, :invite

  GOLDEN_DOLLAR = -1.0

  def initialize(request, invite, params)
    @params = params
    @request = request
    @invite = invite
  end

  def call
    User.transaction do
      user = User.create!(params)

      telegram_notify(user)

      if invite
        membership = Membership.find_by_confirmation_token!(invite)
        membership.user = user
        membership.confirmed_at = Time.now
        membership.save!
      else
        name = params[:email].split('@').first
        Project::Create.(user, request, name: name, credit: GOLDEN_DOLLAR, usage: 0, description: name)
      end

      user
    end
  end

  private

  def telegram_notify(user)
    $telegram_bot.api.send_message(
        chat_id: Rails.application.credentials.fetch(:telegram_bot_contacts_chat_id, 423520819),
        text: "Registered #{user.name} #{user.email} #{user.auth_method}"
    )
  rescue
    return
  end
end
