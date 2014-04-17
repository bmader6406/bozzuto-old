set :user, 'www-data'
set :deploy_to,  "/var/www/bozzuto/staging"
set :branch, 'origin/staging'

set :default_environment, { 'PATH' => '/opt/ruby/bin:$PATH' }

role :web, "bozzuto.staging.vigetx.com"
role :app, "bozzuto.staging.vigetx.com"
role :db,  "bozzuto.staging.vigetx.com", :primary => true
