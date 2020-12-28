class AccessDenied < CustomError
  def initialize(msg = 'access-denied')
    super
  end
end
