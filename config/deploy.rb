# config valid only for current version of Capistrano
lock "3.6.0"

set :application, "stackowf"
set :repo_url, "git@github.com:airwall/stackowf.git"

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, "/home/airwall/stackowf"
set :scm, :git
set :deploy_user, "airwall"
set :tmp_dir, "/home/airwall/tmp"
set :rvm_ruby_version, "ruby-2.3.1"

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push("config/database.yml", ".env", "config/thinking_sphinx.yml")
set :rbenv_map_bins, %w(rake gem bundle ruby rails sidekiq sidekiqctl)

# Default value for linked_dirs is []
append :linked_dirs, "log", "tmp/pids", "tmp/cache", "tmp/sockets", "public/system", "public/uploads"

namespace :deploy do
  desc "Restart Application"
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      invoke "unicorn:restart"
    end
  end
  after :publishing, :restart
end
