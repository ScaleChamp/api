lock "~> 3.14.1"

set :application, 'ScaleChamp'
set :repo_url, 'git@github.com:scalechamp/api.git'
set :user, 'deploy'

set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets .bundle node_modules}

set :rvm_ruby_version, '2.7.1'

set :migration_role, :app

Rake::Task["deploy:assets:backup_manifest"].clear_actions
