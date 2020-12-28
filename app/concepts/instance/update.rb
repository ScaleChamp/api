class Instance::Update < ServiceObject
  attr_reader :current_user, :instance, :params, :request

  def initialize(current_user, request, instance, instance_params)
    @current_user = current_user
    @request = request
    @instance = instance
    @params = instance_params
  end

  def call
    instance.with_lock do
      raise CannotUpdate unless (instance.running? || instance.disabled?)
      raise CannotUpdate if instance.disabled? && params.has_key?(:password) && params[:password] != instance.password

      if params[:enabled] == false and not instance.enabled
        instance.update!(params)
        next
      end

      if params[:enabled] == false and instance.enabled
        # BILLING
        instance.usages.last.update!(ended_at: Time.now)
        # BILLING

        instance.update!(update_params)
        instance.tasks.create!(
            action: "poweroff-#{instance.kind}-#{instance.plan.details['nodes']}",
            kind: instance.kind,
            metadata: {
                **metadata,
                instance_id: instance.id
            }
        )
        next
      end

      if params[:enabled] == true and not instance.enabled
        Plan.active.find(instance.plan_id) # do not power on disabled plans

        # BILLING
        instance.usages.create!(started_at: Time.now, plan: instance.plan, project: instance.project)
        # BILLING

        instance.update!(update_params)

        instance.tasks.create!(
            action: "poweron-#{instance.kind}-#{instance.plan.details['nodes']}",
            kind: instance.kind,
            metadata: {
                instance_id: instance.id,
                plan_id: instance.plan_id,
            }
        )
        next
      end

      if params.has_key?(:password) || params.has_key?(:whitelist) || params.has_key?(:plan_id) || params.has_key?(:eviction_policy)
        nodes = instance.plan.details['nodes']
        new_nodes = instance.plan.details['nodes']

        password_params = {}
        if params.has_key?(:password) && instance.password != params[:password]
          password_params[:new_password] = params[:password]
          password_params[:old_password] = instance.password
        end

        whitelist_params = {}
        if params.has_key?(:whitelist)
          whitelist_params[:whitelist] = params[:whitelist].uniq
        end

        eviction_policy_params = {}
        if params.has_key?(:eviction_policy) && instance.eviction_policy != params[:eviction_policy]
          eviction_policy_params[:eviction_policy] = params[:eviction_policy]
        end

        plan_params = {}
        if params.has_key?(:plan_id) && instance.plan_id != params[:plan_id]
          plan = Plan.active.find(params[:plan_id])

          # TODO allow upgrade and disallow downgrade
          raise CannotUpdate if Gem::Version.new(instance.plan.version) != Gem::Version.new(plan.version)
          # if version changed add version key to plan_params
          new_nodes = plan.details['nodes']

          # BILLING
          updated_at = Time.now
          instance.usages.last.update!(ended_at: updated_at)
          # BILLING

          # move to listener project
          # BILLING
          instance.usages.create!(started_at: updated_at, plan: plan, project: instance.project)
          # BILLING

          plan_params[:plan_id] = plan.id
          plan_params[:password] = params[:password] || instance.password
        end

        if password_params.empty? && plan_params.empty? && whitelist_params.empty? && eviction_policy_params.empty?
          next
        end

        instance.update!(update_params)

        instance.tasks.create!(
            action: "update-#{instance.kind}-#{nodes}-to-#{new_nodes}",
            kind: instance.kind,
            metadata: {
                instance_id: instance.id,
                **password_params,
                **plan_params,
                **whitelist_params,
                **eviction_policy_params,
                **metadata
            }
        )
        next
      end
    end
    instance
  rescue ActiveRecord::RecordNotFound
    raise OutOfStock
  end

  private

  def metadata
    @meta ||= instance.nodes.sort_by { |k| k.metadata['role'] }.map.with_index(1) { |node, idx| ["node#{idx}_id".to_sym, node.id] }.reduce({}) do |total, current|
      total.update(current.first => current.last)
    end
  end

  def update_params
    params.merge(state: :pending)
  end
end
