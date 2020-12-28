class AccessKeyPolicy < ApplicationPolicy
  def permitted_attributes
    [:name, :permission]
  end

  def index?
    user.owner? or user.administrator?
  end

  def show?
    user.owner? or user.administrator?
  end

  def create?
    user.owner? or user.administrator?
  end

  def new?
    create?
  end

  def update?
    user.owner? or user.administrator?
  end

  def edit?
    update?
  end

  def destroy?
    user.owner? or user.administrator?
  end
end
