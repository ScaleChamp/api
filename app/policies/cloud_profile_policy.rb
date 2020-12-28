class CloudProfilePolicy < ApplicationPolicy
  def permitted_attributes
    [:cloud, :region, :credentials]
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
