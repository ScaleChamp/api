class Membership < ApplicationRecord
  enum role: {
      owner: 0,
      accountant: 1,
      administrator: 2,
      member: 3
  }

  JOINED = 'joined'
  PENDING = 'pending'

  validates :role, presence: true

  validates :email, uniqueness: {scope: :project}, format: {with: URI::MailTo::EMAIL_REGEXP}, presence: true

  validates_uniqueness_of :user_id, scope: :project_id, unless: -> { self.user.blank? }

  belongs_to :user, optional: true

  belongs_to :project

  def send_invitation_to_user!
    MembershipMailer.with(membership: self).invite_existing_user.deliver_later
  end

  def send_invitation_to_email!
    MembershipMailer.with(membership: self).invite_new_user.deliver_later
  end
end
