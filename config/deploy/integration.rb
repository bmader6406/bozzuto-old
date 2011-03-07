set :user, 'apache'
set :deploy_to,  "/var/www/html/#{application}/integration"
set :branch, 'origin/master'

set :default_environment, { 'PATH' => '/opt/ree/bin:$PATH' }

role :web, "pottsville.lab.viget.com"
role :app, "pottsville.lab.viget.com"
role :db,  "pottsville.lab.viget.com", :primary => true

