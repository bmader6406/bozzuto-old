set :application, 'bozzuto'
set :user,        'www-data'
set :deploy_to,   "/var/www/#{application}"
set :branch,      "origin/production"

role :web, "54.241.3.36"
role :app, "54.241.3.36"
role :db,  "54.241.3.36", :primary => true

after "deploy", "refresh_sitemaps"
