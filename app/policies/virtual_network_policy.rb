class VirtualNetworkPolicy < ApplicationPolicy
  def permitted_attributes
    [:vpc_id, :network]
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

  def destroy?
    user.owner? or user.administrator?
  end
end
