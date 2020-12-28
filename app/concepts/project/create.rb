class Project::Create < ServiceObject
  attr_reader :owner, :project_params, :request

  def initialize(owner, request, project_params)
    @owner = owner
    @project_params = project_params
    @request = request
  end

  def call
    Project.transaction do
      project = Project.create!(project_params)

      CertificateAuthority::Create.(project)

      if project.credit == -500
        project.credit = 0
        project.save!
      end

      Membership.create!(
          role: :owner,
          email: owner.email,
          confirmed_at: Time.now,
          user: owner,
          project: project,
      )
      if project.credit.zero?
        project.events.create(
            metadata: {
                description: Project::JUST_CREATED
            }
        )
      else
        project.events.create(
            data: {
                amount: -project.credit
            },
            metadata: {
                description: Project::PROMOTIONAL_CREDIT
            }
        )
      end
      owner.security_logs.create!(
          action_type: SecurityLog::PROJECT_CREATED,
          remote_ip: request.remote_ip,
          data: project
      )
      project.audit_logs.create!(
          action_type: AuditLog::PROJECT_CREATED,
          user: owner,
          remote_ip: request.remote_ip
      )
      project
    end
  end
end
