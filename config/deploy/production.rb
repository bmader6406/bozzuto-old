set :application, 'bozzuto'
set :user,        'deploy'
set :deploy_to,   "/var/www/#{application}/production"
set :branch,      "origin/production"

role :web, "54.215.11.223:8022"
role :app, "54.215.11.223:8022"
role :db,  "54.215.11.223:8022", :primary => true

after "deploy", "refresh_sitemaps"
