set :application, 'bozzuto'
set :user,        'www-data'
set :deploy_to,   "/var/www/#{application}"
set :branch,      "origin/production_new"

set :default_environment, { 'PATH' => '/usr/local/rbenv/shims:/usr/local/rbenv/bin:$PATH' }

role :web, "54.241.3.36"
role :app, "54.241.3.36"
role :db,  "54.241.3.36", :primary => true


namespace :config do
  desc '[internal] Sets default values for some variables.'
  task :defaults do
    set :rails_env, 'production'
  end
end
