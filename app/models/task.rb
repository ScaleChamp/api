class Task < ApplicationRecord
  enum state: {
      running: 0,
      completed: 1,
      failed: 2,
  }

  after_commit :publish, on: :create

  belongs_to :instance

  def publish
    $tasks.publish(self.to_json)
  end

  def self.republish(task)
    instance = task.instance
    instance.with_lock do
      instance.pending!
      instance.tasks.create!(kind: task.kind, action: task.action, metadata: task.metadata)
    end
  end
end
