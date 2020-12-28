github_app_id = Rails.application.credentials.fetch(:github_app_id)
github_app_secret = Rails.application.credentials.fetch(:github_app_secret)
google_client_id = Rails.application.credentials.fetch(:google_client_id)
google_client_secret = Rails.application.credentials.fetch(:google_client_secret)

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, github_app_id, github_app_secret, {
      path_prefix: '/sessions',
      scope: "user:email"
  }
  provider :github, github_app_id, github_app_secret, {
      path_prefix: '/registrations',
      scope: "user:email"
  }
  provider :github, github_app_id, github_app_secret, {
      path_prefix: '/logins',
      scope: "user:email"
  }
  provider :google_oauth2, google_client_id, google_client_secret, {
      name: 'google',
      path_prefix: '/sessions',
      prompt: 'select_account'
  }
  provider :google_oauth2, google_client_id, google_client_secret, {
      name: 'google',
      path_prefix: '/registrations',
      prompt: 'select_account'
  }
  provider :google_oauth2, google_client_id, google_client_secret, {
      name: 'google',
      path_prefix: '/logins',
      prompt: 'select_account'
  }
end
