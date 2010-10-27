set :user, 'apache'
set :deploy_to,  "/var/www/#{application}"
set :branch, "origin/production"

role :web, "bozzuto.com"
role :app, "bozzuto.com"
role :db,  "bozzuto.com", :primary => true
