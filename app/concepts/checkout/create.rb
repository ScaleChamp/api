class Checkout::Create < ServiceObject
  MIN = 5

  attr_reader :current_user, :params, :project

  def initialize(current_user, params, project)
    @current_user = current_user
    @params = params
    @project = project
  end

  def call
    response = Paddle.generate_pay_link(
        customer_email: current_user.email,
        price: sprintf("%.02f", (price * rate).round(2)),
        currency: project.currency,
        project_name: project.name,
        passthrough: {
            project_id: project.id,
            price: price,
            user_id: current_user.id
        }
    )
    raise ActiveRecord::RecordNotFound unless response.fetch('success', false)
    response.dig('response', 'url')
  end

  private

  def price
    raise CustomError if params[:amount].to_i < MIN
    params[:amount].to_i
  end

  def rate
    return 1 if project.usd?
    Rate.find_by_currency(project.currency).try(:rate) ||
        ExchangeClient.latest.fetch('rates').fetch(project.currency.upcase)
  end
end
