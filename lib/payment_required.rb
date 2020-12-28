class PaymentRequired < CustomError
  def initialize(msg = 'need-more-money')
    super
  end
end
