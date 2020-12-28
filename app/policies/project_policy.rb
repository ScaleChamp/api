class ProjectPolicy < ApplicationPolicy
  def permitted_attributes
    [:name, :description, :currency]
  end

  def show?
    true
  end

  def update?
    user.owner? || user.accountant?
  end

  def destroy?
    user.owner?
  end
end
