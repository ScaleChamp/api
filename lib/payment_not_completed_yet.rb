class PaymentNotCompletedYet < CustomError
  def initialize(msg = 'payment-not-completed-yet')
    super
  end
end
