namespace :operation do
  desc "Power off instance"
  # RAILS_ENV=production ./bin/rails "operation:poweroff[`uuidgen`]"

  task :poweroff, [:id] => [:environment] do |t, params|
    project = Project.find(params[:id])
    Project::PowerOff.(project)
  end
end
