class Membership::Invite < ServiceObject
  attr_reader :current_user, :project, :params

  def initialize(current_user, project, params)
    @current_user = current_user
    @project = project
    @params = params
  end

  def call
    membership = project.memberships.find_by_email(params[:email])

    if membership && membership.confirmed_at.blank?
      membership.confirmation_sent_at = Time.now
      membership.confirmation_token = SecureRandom.hex(32)
      membership.save!
    else
      membership = project.memberships.create!(
          email: params[:email],
          role: params[:role],
          confirmation_sent_at: Time.now,
          confirmation_token: SecureRandom.hex(32)
      )
    end
    if User.find_by_email(params[:email])
      membership.send_invitation_to_user!
    else
      membership.send_invitation_to_email!
    end
    membership
  end
end
