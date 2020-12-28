class SecurityLog < ApplicationRecord
  TFA_OTP_START = 'tfa.otp_start'
  LOGIN_SUCCESS = 'login.success'
  LOGIN_FAILURE = 'login.failure'
  USER_NOT_CONFIRMED = 'auth_method.user_was_not_confirmed'
  NOT_EMAIL_FAILURE = 'auth_method.not_email_failure'
  AUTH_METHOD_UPDATE = 'auth_method.update'
  PROJECT_CREATED = 'project.created'
  EMAIL_CONFIRM = 'email.confirm'
  EMAIL_RECONFIRM = 'email.reconfirm'
  OAUTH_LOGIN = 'auth_method.oauth_login'
  LOGIN_NOT_THIS = 'auth_method.not_this_method_failure'

  belongs_to :user
end
