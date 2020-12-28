class OutOfStock < CustomError
  def initialize(msg = 'out-of-stock')
    super
  end
end
