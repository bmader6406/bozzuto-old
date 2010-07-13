set :user, 'apache'
set :deploy_to,  "/var/www/#{application}"

role :web, "bozweb.bozzuto.com"
role :app, "bozweb.bozzuto.com"
role :db,  "bozweb.bozzuto.com", :primary => true
