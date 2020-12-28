server '5.102.147.173', user: 'deploy', roles: [:web, :app], primary: true

set :branch, 'vpcs'
set :linked_files, fetch(:linked_files, []).push('config/credentials/production.key')

before "deploy:assets:precompile", "deploy:yarn_install"

namespace :deploy do
  desc "Run rake yarn install"
  task :yarn_install do
    on roles(:web) do
      within release_path do
        execute("cd #{release_path} && yarn install --silent --no-progress --no-audit --no-optional")
      end
    end
  end
end
