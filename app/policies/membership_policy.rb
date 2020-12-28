class MembershipPolicy < ApplicationPolicy
  def permitted_attributes_for_create
    [:email, :role]
  end

  def permitted_attributes_for_update
    [:role]
  end

  def index?
    user.owner? or user.administrator? or user.member?
  end

  def show?
    user.owner? or user.administrator? or user.member?
  end

  def create?
    user.owner? or user.administrator?
  end

  def new?
    create?
  end

  def update?
    (record.user != user.user) && (user.owner? || (user.administrator? && !record.owner?))
  end

  def edit?
    update?
  end

  def destroy?
    update?
  end
end
