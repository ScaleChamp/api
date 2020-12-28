class CannotUpdate < CustomError
  def initialize(msg = 'cannot-update')
    super
  end
end
