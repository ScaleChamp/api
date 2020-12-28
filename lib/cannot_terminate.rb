class CannotTerminate < CustomError
  def initialize(msg = 'cannot-terminate')
    super
  end
end
