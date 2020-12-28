class PeerPolicy < ApplicationPolicy
  def permitted_attributes
    [:aws_peer_owner_id, :aws_peer_region, :aws_peer_vpc_id]
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
