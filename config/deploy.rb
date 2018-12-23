# config valid for current version and patch releases of Capistrano
lock "~> 3.11.0"

set :application, "my_app_name"
set :repo_url, "git@github.com:yuneszadi/qna.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/deployer/qna"
set :deploy_user, "deployer"

# Default value for :linked_files is []
append :linked_files, "config/database.yml"

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system"

namespace :deploy do
  desc "Restart application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end

  after :publishing, :restart
end

namespace :sphinx do
  desc "Restart Sphinx"
  task :restart do
    on roles(:app) do
      within current_path do
        with rails_env: fetch(:rails_env) do
          execute :bundle, "exec rake ts:configure"
          execute :bundle, "exec rake ts:index"
        end
      end
    end
  end
end

after "deploy:restart", "sphinx:restart"
