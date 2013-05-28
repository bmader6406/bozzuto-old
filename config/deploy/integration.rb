set :user, 'www-data'
set :deploy_to,  "/var/www/bozzuto/integration"
set :branch, 'origin/master'

set :default_environment, { 'PATH' => '/opt/ruby/bin:$PATH' }

role :web, "bozzuto.integration.vigetx.com"
role :app, "bozzuto.integration.vigetx.com"
role :db,  "bozzuto.integration.vigetx.com", :primary => true

