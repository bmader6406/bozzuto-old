set :user, 'apache'
set :deploy_to,  "/var/www/#{application}"
set :branch, "origin/production"

set :default_environment, { 'PATH' => '/opt/ruby-enterprise-1.8.7-2010.02/bin:$PATH' }

role :web, "bozzuto.com"
role :app, "bozzuto.com"
role :db,  "bozzuto.com", :primary => true
