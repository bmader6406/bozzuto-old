set :user,          'www-data'
set :deploy_to,     "/var/www/bozzuto/modernization"
set :branch,        'origin/modernization'
set :slack_app_url, 'http://bozzuto.modernization.vigetx.com'

server 'bozzuto.modernization.vigetx.com', :web, :app, :db, primary: true
