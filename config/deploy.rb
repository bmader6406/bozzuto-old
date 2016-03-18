require 'viget/deployment/rails'
require 'capistrano-resque'

set :application, 'bozzuto'

set :slack_url,     'https://hooks.slack.com/services/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'
set :slack_channel, '#bozzuto'
set :slack_emoji,   ':sparkles:'

set :sync_directories, ["public/system"]
set :sync_backups, 3

set :workers, { '*' => 1 }
set :resque_environment_task, true

after "deploy:restart", "resque:restart"

desc 'watch logs'
task :logs, :roles => :app do
  stream "tail -n 0 -f #{shared_path}/log/*.log"
end

desc "Refresh Sitemaps"
task :refresh_sitemaps do
  run "cd #{latest_release} && RAILS_ENV=#{rails_env} bundle exec rake sitemap:refresh"
end
