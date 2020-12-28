class MembershipMailer < ApplicationMailer
  JOIN_PROJECT = "Join Project"

  def invite_new_user
    membership = params[:membership]
    mail(
        to: membership.email,
        subject: JOIN_PROJECT,
        template_name: __method__.to_s,
        params: {
            confirmation_path: "#{ApplicationMailer::HOST}/register?invite=#{membership.confirmation_token}",
            confirmation_sent_at: membership.confirmation_sent_at
        }
    )
  end

  def invite_existing_user
    membership = params[:membership]
    mail(
        to: membership.email,
        subject: JOIN_PROJECT,
        template_name: __method__.to_s,
        params: {
            confirmation_path: "#{ApplicationMailer::HOST}/projects/?invite=#{membership.confirmation_token}",
            confirmation_sent_at: membership.confirmation_sent_at
        }
    )
  end
end
