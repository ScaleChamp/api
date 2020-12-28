class Instance::Destroy < ServiceObject
  attr_reader :instance, :current_user, :request

  def initialize(current_user, instance, request)
    @current_user = current_user
    @instance = instance
    @request = request
  end

  def call
    instance.with_lock do
      begin
        # wasabi
        $iam.delete_access_key(access_key_id: instance.access_key_pair.access_key_id, user_name: instance.id)
        $iam.remove_user_from_group(group_name: GROUP_NAME, user_name: instance.id)
        $iam.delete_user(user_name: instance.id)
      rescue Aws::IAM::Errors::NoSuchEntity
        puts "role #{instance.id} already removed"
      end
      disabled = instance.disabled?
      raise CannotTerminate unless (instance.running? || disabled)
      instance.update!(state: :terminated)
      destroy_nodes unless disabled
    end
  end

  private

  def destroy_nodes
    # BILLING
    instance.usages.last.update!(ended_at: Time.now)
    # BILLING
    metadata = instance.nodes.map.with_index(1) do |node, idx|
      [
          "node#{idx}_id",
          node.id
      ]
    end.reduce({}) do |total, current|
      total.update(current.first => current.last)
    end
    instance.project.audit_logs.create!(
        action_type: AuditLog::INSTANCE_DESTROY,
        remote_ip: request.remote_ip,
        data: instance,
        user: current_user
    )
    instance.tasks.create!(
        kind: instance.kind,
        action: "destroy-#{instance.kind}-#{instance.nodes.size}",
        metadata: metadata
    )
  end
end

# f72f4d00-4b86-400f-ab10-eed0c3dafb90
# 4d6af9fe-982d-413b-a9af-2776504cba46
# 3286f337-6b67-4ba9-88f9-1e2cd2189266
# a04f628b-54ee-4dfe-9c44-1bd6a52cc703
#
# 7073e8fe-4b02-4fa4-a498-6eec5779fcef
# 52b85361-065c-4d72-bffa-394abd20e4b9
# 8ceda0d3-d431-4e09-acea-f3835cfff68c
# 2fc172d2-ef95-457d-a461-69a2a3019d0e
