require 'bundler/capistrano'

set :application, 'bozzuto_app'
set :repository, 'git@github.com:vigetlabs/bozzuto.git'
set :scm, :git

set :use_sudo, false

set :stages, %w( integration staging production )
set :default_stage, 'integration'

set(:latest_release) { fetch(:current_path) }
set(:release_path) { fetch(:current_path) }
set(:current_release) { fetch(:current_path) }

set(:current_revision) { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:latest_revision) { capture("cd #{current_path}; git rev-parse --short HEAD").strip }
set(:previous_revision) {
  capture("cd #{current_path}; git rev-parse --short HEAD@{1}").strip
}

set :sync_directories, ["public/system"]
set :sync_backups, 3

after 'multistage:ensure', 'config:defaults'
after 'deploy:update_code', 'app:package_assets'
after 'deploy:update_code', 'app:clear_asset_caches'
after 'deploy:update_code', 'app:update_crontab'
after "deploy", "refresh_sitemaps"

namespace :deploy do
  task :start do
  end

  task :stop do
  end

  task :restart, :roles => :app, :except => {:no_release => true} do
    run "#{try_sudo} touch #{File.join(current_path, 'tmp', 'restart.txt')}"
  end

  desc 'Deploy'
  task :default do
    update
    restart
  end

  desc 'Setup a GitHub-style deployment.'
  task :setup, :except => {:no_release => true} do
    dirs = [deploy_to, shared_path]
    dirs += shared_children.map { |d| File.join(shared_path, d) }
    run "#{try_sudo} mkdir -p #{dirs.join(' ')} && #{try_sudo} chmod g+w #{dirs.join(' ')}"
    run "git clone #{repository} #{current_path}"
    run "cp #{current_path}/config/database.sample.yml #{current_path}/config/database.yml"
  end

  task :update do
    transaction do
      update_code
    end
  end

  desc 'Update the deployed code.'
  task :update_code, :except => {:no_release => true} do
    run "cd #{current_path}; git fetch origin; git reset --hard #{branch}"
    finalize_update
  end

  desc 'Update the database (overwritten to avoid symlink)'
  task :migrations do
    update_code
    migrate
    restart
  end

  namespace :rollback do
    desc 'Moves the repo back to the previous version of HEAD'
    task :repo, :except => {:no_release => true} do
      set :branch, 'HEAD@{1}'
      deploy.default
    end

    desc 'Rewrite reflog so HEAD@{1} will continue to point to at the next previous release.'
    task :cleanup, :except => {:no_release => true} do
      run "cd #{current_path}; git reflog delete --rewrite HEAD@{1}; git reflog delete --rewrite HEAD@{1}"
    end

    desc 'Rolls back to the previously deployed version.'
    task :default do
      rollback.repo
      rollback.cleanup
    end
  end
end

namespace :app do
  desc 'Package assets for the live site'
  task :package_assets do
    run "cd #{current_path}; bundle exec jammit"
  end

  desc 'Remove asset caches'
  task :clear_asset_caches do
    run "rm -f #{release_path}/public/javascripts/all.js"
    run "rm -f #{release_path}/public/stylesheets/all.css"
  end

  desc 'Update the crontab file'
  task :update_crontab do
    env = fetch(:rails_env)
    run "cd #{release_path}; bundle exec whenever  --update-crontab #{application + '_' + env} --set 'environment=#{env}&cron_log=#{release_path}/log/cron.log'"
  end
end

namespace :config do
  desc '[internal] Sets default values for some variables.'
  task :defaults do
    set :rails_env, fetch(:stage).to_s
  end
end

desc 'watch logs'
task :logs, :roles => :app do
  stream "tail -n 0 -f #{shared_path}/log/*.log"
end

desc "Refresh Sitemaps"
task :refresh_sitemaps do
  run "cd #{latest_release} && RAILS_ENV=#{rails_env} bundle exec rake sitemap:refresh"
end

Dir[File.join(File.dirname(__FILE__), '..', 'vendor', 'gems', 'hoptoad_notifier-*')].each do |vendored_notifier|
  $: << File.join(vendored_notifier, 'lib')
end

require 'hoptoad_notifier/capistrano'
