class PaddleMailer < ApplicationMailer
  def send_invoice
    @user = params[:user]
    @project = params[:project]
    @checkout = params[:checkout]
    mail(
        to: @user.email,
        subject: "Payment Success!",
        template_name: __method__.to_s,
        params: {
            name: @user.name,
            project: @project.name,
            amount: @checkout.amount
        }
    )
  end
end
