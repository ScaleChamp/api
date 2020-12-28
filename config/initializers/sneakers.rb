require 'bunny'
require 'sneakers'

if defined?(PhusionPassenger)
  PhusionPassenger.on_event(:starting_worker_process) do |forked|
    if forked
      $bunny = Bunny.new(Rails.application.credentials.fetch(:rabbit_url))
      Sneakers.configure(connection: $bunny)
      $tasks = Sneakers::Publisher.new(exchange: 'tasks')
    end
  end

  PhusionPassenger.on_event(:stopping_worker_process) do
    $bunny.close if $bunny
  end
else
  $bunny = Bunny.new(Rails.application.credentials.fetch(:rabbit_url))

  Sneakers.configure(connection: $bunny)

  $tasks = Sneakers::Publisher.new(exchange: 'tasks')

  at_exit do
    $bunny.close
  end
end
