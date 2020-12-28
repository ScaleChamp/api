class Project::Suspend < ServiceObject
  attr_reader :project

  def initialize(project)
    @project = project
  end

  def call
    project.instances.running.each do |instance|
      Instance::Update.(nil, nil, instance, {enabled: false}) if instance.enabled
    rescue => e
      puts e.to_s
    end
    # send an email about suspend
  end
end
