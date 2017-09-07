require 'viget/deployment/rails'
require 'capistrano-resque'

set :application, 'bozzuto'

# set :slack_url,     'https://hooks.slack.com/services/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'
# set :slack_channel, '#bozzuto'
# set :slack_emoji,   ':sparkles:'

set :sync_directories, ["public/system"]
set :sync_backups, 3

set :workers, { '*' => 1 }
set :resque_environment_task, true

after "deploy:restart", "resque:restart"
before "deploy:restart", "algoliasearch:set_index_settings"
before "deploy:restart", "algoliasearch:reindex"

desc 'watch logs'
task :logs, :roles => :app do
  stream "tail -n 0 -f #{shared_path}/log/*.log"
end

desc "Refresh Sitemaps"
task :refresh_sitemaps do
  run "cd #{latest_release} && RAILS_ENV=#{rails_env} bundle exec rake sitemap:refresh"
end

namespace :algoliasearch do
  desc "Set Algolia Setting"
  task :set_index_settings do
    run_rake_task 'algoliasearch:set_index_settings'
  end

  desc "Reindex Algolia"
  task :reindex do
    run_rake_task 'algoliasearch:reindex'
  end
end
