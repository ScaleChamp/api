class InstancePolicy < ApplicationPolicy
  def permitted_attributes
    [:project_id, :id, :name, :plan_id, :password, :enabled, :license_key, :eviction_policy, whitelist: []]
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
    user.owner? or user.administrator?
  end

  def edit?
    update?
  end

  def destroy?
    user.owner? or user.administrator?
  end
end
