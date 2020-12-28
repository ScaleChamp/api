module FormAuthenticityToken
  extend ActiveSupport::Concern

  included do
    after_action :set_form_authenticity_token
  end

  def set_form_authenticity_token
    cookies[:_csrf_token] = {
        value: form_authenticity_token,
        same_site: :strict
    }
  end
end
