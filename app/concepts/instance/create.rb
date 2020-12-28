class Instance::Create < ServiceObject
  MAX_COUNT = 10

  attr_reader :current_user, :project, :params, :request

  def initialize(current_user, project, params, request)
    @current_user = current_user
    @project = project
    @params = params
    @request = request
  end

  def call
    telegram_notify
    Instance.transaction do
      plan = Plan.active.find(params[:plan_id])

      raise PaymentRequired if (project.credit + project.usage + plan.price) >= 0
      raise OutOfStock if Instance.running.count >= MAX_COUNT

      instance = project.instances.create!(
          eviction_policy: params[:eviction_policy] || 'noeviction',
          license_key: params[:license_key],
          password: SecureRandom.base58(32),
          secret: SecureRandom.base58(32),
          name: params[:name],
          plan_id: params[:plan_id],
          kind: plan.kind,
          whitelist: (params[:whitelist] || []).sort.uniq,
          metadata: params[:metadata] || {},
          connection_info: {},
      )

      # wasabi
      $iam.create_user(user_name: instance.id)
      $iam.wait_until(:user_exists, user_name: instance.id)
      $iam.add_user_to_group(group_name: GROUP_NAME, user_name: instance.id)
      response = $iam.create_access_key(user_name: instance.id)

      instance.create_access_key_pair!(
          access_key_id: response.access_key.access_key_id,
          secret_access_key: response.access_key.secret_access_key,
      )

      # BILLING move to listener
      instance.usages.create!(started_at: instance.created_at, plan: plan, project: project)
      # BILLING

      instance.tasks.create!(
          kind: instance.kind,
          action: "create-#{instance.kind}-#{instance.plan.details['nodes']}",
          metadata: {
              instance_id: instance.id,
              plan_id: plan.id
          }
      )
      project.audit_logs.create!(
          action_type: AuditLog::INSTANCE_CREATED,
          remote_ip: request.remote_ip,
          data: instance,
          user: current_user
      )
      instance
    end
  rescue ActiveRecord::RecordNotFound
    raise OutOfStock
  end

  private

  def telegram_notify
    plan = Plan.find(params[:plan_id])
    $telegram_bot.api.send_message(
        chat_id: Rails.application.credentials.fetch(:telegram_bot_contacts_chat_id, 423520819),
        text: "User #{current_user.try(:id)} want #{plan.kind} #{plan.cloud} #{plan.id}"
    )
  rescue
    return
  end
end

