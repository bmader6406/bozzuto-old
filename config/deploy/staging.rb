set :user, 'apache'
set :deploy_to,  "/var/www/html/#{application}/staging"
set :branch, 'origin/staging'

role :web, "pottsville.lab.viget.com"
role :app, "pottsville.lab.viget.com"
role :db,  "pottsville.lab.viget.com", :primary => true
