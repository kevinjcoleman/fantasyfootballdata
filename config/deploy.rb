# config valid only for current version of Capistrano
lock "3.9.0"

after 'deploy:published', 'system:update_jobs'

set :application, 'fantasyfootballdata'
set :repo_url, 'git@github.com:kevinjcoleman/fantasyfootballdata.git'

# Default branch is :master
set :branch, :master

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, '/home/deploy/fantasyfootballdata'

# Default value for :pty is false
set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/application.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system public/uploads}
set :bundle_binstubs, nil

# Default value for keep_releases is 5
set :keep_releases, 3
set :rvm_type, :user
set :rvm_ruby_version, 'ruby-2.4.1'

set :puma_rackup, -> { File.join(current_path, 'config.ru') }
set :puma_state, "#{shared_path}/tmp/pids/puma.state"
set :puma_pid, "#{shared_path}/tmp/pids/puma.pid"
set :puma_bind, "unix://#{shared_path}/tmp/sockets/puma.sock"    #accept array for multi-bind
set :puma_conf, "#{shared_path}/puma.rb"
set :puma_access_log, "#{shared_path}/log/puma_error.log"
set :puma_error_log, "#{shared_path}/log/puma_access.log"
set :puma_role, :app
set :puma_env, fetch(:rack_env, fetch(:rails_env, 'production'))
set :puma_threads, [0, 8]
set :puma_workers, 0
set :puma_worker_timeout, nil
set :puma_init_active_record, true
set :puma_preload_app, false

namespace :system do
  desc 'Update the system jobs'
  task :update_jobs do
    on roles(:app) do
      within release_path do
        with rails_env: fetch(:rails_env) do
          execute :rake, 'recurring:init'
        end
      end
    end
  end
end

# Clear existing task so we can replace it rather than "add" to it.
Rake::Task["deploy:compile_assets"].clear

namespace :deploy do

  desc 'Compile assets'
  task :compile_assets => [:set_rails_env] do
    # invoke 'deploy:assets:precompile'
    invoke 'deploy:assets:precompile_local'
    invoke 'deploy:assets:backup_manifest'
  end


  namespace :assets do
    desc "Precompile assets locally and then rsync to web servers"
    task :precompile_local do
      puts "starting precompile"
      # compile assets locally

      run_locally do
        `RAILS_ENV=#{fetch(:stage)} bundle exec rake assets:precompile`
      end
      puts "finished precompile"

      # rsync to each server
      dirs = {
        './public/assets/' => 'public/assets/',
        './public/packs/' => 'public/packs/'
      }
      on roles( fetch(:assets_roles, [:web]) ) do
        # this needs to be done outside run_locally in order for host to exist
        dirs.each do |local, remote|
          puts "running rsync for #{local}"
          remote_dir = "#{host.user}@#{host.hostname}:#{release_path}/#{remote}"
          run_locally { `rsync -av --delete #{local} #{remote_dir}` }
        end
      end

      # clean up
      run_locally { execute "rm -rf #{dirs.keys.first}" }
    end

  end
end
