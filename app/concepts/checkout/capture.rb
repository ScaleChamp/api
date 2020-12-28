class Checkout::Capture < ServiceObject
  attr_reader :current_user, :entity, :id

  def initialize(current_user, entity, id)
    @current_user = current_user
    @entity = entity
    @id = id
  end

  def call
    response = Paddle.transactions(entity: entity, id: id)
    raise ActiveRecord::RecordNotFound unless response.fetch('success', false)

    transaction = response.dig('response', 0)
    paddle_id = transaction.fetch('checkout_id')
    status = transaction.fetch('status')
    passthrough = JSON.parse(transaction.fetch('passthrough'))
    user_id = passthrough.fetch('user_id')
    project_id = passthrough.fetch('project_id')
    price = passthrough.fetch('price')

    raise AccessDenied unless (current_user.try(:id) || user_id) == user_id
    raise PaymentNotCompletedYet unless status == 'completed'

    project = Project.find(project_id)
    user = User.find(user_id)

    project.with_lock do
      found = true
      checkout = project.checkouts.find_or_create_by!(paddle_id: paddle_id, user: user) do |c|
        found = false
        c.amount = price
      end
      return project if found
      project.events.create!(
          data: checkout,
          metadata: {
              description: Project::USER_PAYMENT
          }
      )
      project.credit -= checkout.amount
      project.save!
      notify_user(user, project, checkout)
      project
    end
  end

  def notify_user(user, project, checkout)
    PaddleMailer.with(user: user, project: project, checkout: checkout).send_invoice.deliver_now
  rescue
    puts 'Error in paddle mailer!!!'
  end
end


