require 'viget/deployment/rails'

set :application, 'bozzuto'

set :slack_url,     'https://hooks.slack.com/services/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'
set :slack_channel, '#bozzuto'
set :slack_emoji,   ':sparkles:'

set :sync_directories, ["public/system"]
set :sync_backups, 3

after 'deploy:update_code', 'app:package_assets'
after 'deploy:update_code', 'app:clear_asset_caches'

namespace :app do
  desc 'Package assets for the live site'
  task :package_assets do
    run "cd #{release_path} && bundle exec jammit"
  end

  desc 'Remove asset caches'
  task :clear_asset_caches do
    run "rm -f #{release_path}/public/javascripts/all.js"
    run "rm -f #{release_path}/public/stylesheets/all.css"
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
