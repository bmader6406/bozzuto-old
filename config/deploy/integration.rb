set :user,      'www-data'
set :deploy_to, '/var/www/bozzuto/integration'
set :branch,    fetch(:branch, 'origin/master')

set :default_environment, { 'PATH' => '/opt/rbenv/versions/ree-1.8.7-2012.02/bin:$PATH' }

role :web, 'bozzuto.integration.vigetx.com'
role :app, 'bozzuto.integration.vigetx.com'
role :db,  'bozzuto.integration.vigetx.com', :primary => true

