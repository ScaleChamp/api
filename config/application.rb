require_relative 'boot'

require "rails"
# Pick the frameworks you want:
require "active_model/railtie"
require "active_job/railtie"
require "active_record/railtie"
# require "active_storage/engine"
require "action_controller/railtie"
require "action_mailer/railtie"
require "action_view/railtie"
# require "action_cable/engine"
# require "sprockets/railtie"
# require "rails/test_unit/railtie"

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module ScaleChamp
  class Application < Rails::Application
    config.load_defaults 6.0
    config.force_ssl = Rails.env.production?
    config.ssl_options = {hsts: {expires: 10.days}}
    config.autoload_paths << Rails.root.join("lib")
    config.eager_load_paths << Rails.root.join("lib")
    config.hosts << /[a-z0-9]+\.scalechamp\.com/
    config.session_store :cookie_store,
                         key: '_scalechamp_session',
                         secure: Rails.env.production?,
                         expire_after: 8.hours
    config.generators.system_tests = nil
  end
end
