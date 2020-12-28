class InvoicePolicy < ApplicationPolicy
  def show?
    user.owner? or user.accountant?
  end
end
