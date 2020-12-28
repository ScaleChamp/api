class LogPolicy < ApplicationPolicy
  def index?
    user.owner? or user.administrator? or user.member?
  end
end
