class ApplicationMailer < ActionMailer::Base
  default from: 'ScaleChamp <support@scalechamp.com>'

  HOST = Rails.application.credentials.fetch(:email_website, 'http://dev.scalablespace.net:3000')

  def mail(**options)
    Notifier::Client.mail(default_params.merge(options))
  end
end
