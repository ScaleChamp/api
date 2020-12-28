class UserMailer < ApplicationMailer
  def verify_email
    @user = params[:user]
    mail(
        to: @user.email,
        subject: "Verify Your Email",
        template_name: __method__.to_s,
        params: {
            confirmation_path: "#{ApplicationMailer::HOST}/confirmations/#{@user.confirmation_token}"
        }
    )
  end

  def verify_unconfirmed_email
    @user = params[:user]
    mail(
        to: @user.unconfirmed_email,
        subject: "Verify Your New Email",
        template_name: __method__.to_s,
        params: {
            confirmation_path: "#{ApplicationMailer::HOST}/confirmations/#{@user.confirmation_token}"
        }
    )
  end

  def email_confirmed
    @user = params[:user]
    mail(
        to: @user.email,
        subject: "Welcome to ScaleChamp!",
        template_name: __method__.to_s,
        params: {
            name: @user.name
        }
    )
  end

  def password_reset
    @user = params[:user]
    mail(
        to: @user.email,
        subject: "Reset Your Password",
        template_name: __method__.to_s,
        params: {
            password_reset_path: "#{ApplicationMailer::HOST}/forgot/password?token=#{@user.reset_password_token}",
            reset_password_sent_at: @user.reset_password_sent_at
        }
    )
  end
end
