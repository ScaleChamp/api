class SuspendWorker
  include Sneakers::Worker

  from_queue :stop

  def work(message)
    params = JSON.parse(message)
    project = Project.find(params.fetch('id'))
    Project::Suspend.(project)
    ack!
  rescue ActiveRecord::RecordNotFound, KeyError
    reject!
  end
end
