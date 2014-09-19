set :user,      'www-data'
set :deploy_to, '/var/www/bozzuto/integration'
set :branch,    fetch(:branch, 'origin/master')

role :web, 'bozzuto.integration.vigetx.com'
role :app, 'bozzuto.integration.vigetx.com'
role :db,  'bozzuto.integration.vigetx.com', :primary => true

