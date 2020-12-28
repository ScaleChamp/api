class EventPolicy < ApplicationPolicy
  def index?
    user.owner? or user.accountant?
  end
end
